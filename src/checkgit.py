import asyncio
import json
import os
import re
import sys
import tomllib
from typing import Any, Dict, List, Tuple


class GitChecker:
    """Asynchronous checker for git repository HEAD revisions."""
    
    def __init__(self, max_concurrent: int = 5):
        self.semaphore = asyncio.Semaphore(max_concurrent)
        self.completed_count = 0
        self.total_count = 0
        self.returncode = 0
        
    async def get_head_revision(self, url: str) -> Tuple[str, int]:
        """Get the HEAD revision for a given git repository URL."""
        try:
            proc = await asyncio.create_subprocess_exec(
                "git",
                "ls-remote",
                url,
                "HEAD",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE
            )
            stdout, stderr = await proc.communicate()
            
            if proc.returncode == 0:
                # Extract revision hash from git output
                revision = re.sub(r"\s.*", "", stdout.decode().strip())
                return revision, 0
            else:
                print(f"Error checking {url}: {stderr.decode()}", file=sys.stderr)
                return "", proc.returncode
        except Exception as e:
            print(f"Exception checking {url}: {str(e)}", file=sys.stderr)
            return "", 1
    
    def update_progress(self) -> None:
        """Update the progress bar in the terminal."""
        self.completed_count += 1
        
        try:
            terminal_cols = os.get_terminal_size(2).columns
        except OSError:
            # Fallback if terminal size is not available
            terminal_cols = 80
            
        bar_width = terminal_cols - 2  # Reserve space for brackets
        filled_width = int((bar_width * self.completed_count) / self.total_count)
        empty_width = bar_width - filled_width
        
        progress_bar = "[" + ("=" * filled_width) + (" " * empty_width) + "]"
        print(progress_bar, end="\r", file=sys.stderr)
        
        if self.completed_count == self.total_count:
            print(file=sys.stderr)  # New line when complete
    
    async def check_single_repo(self, repo_data: Tuple[str, Dict[str, Any]]) -> Tuple[str, Dict[str, Any]]:
        """Check a single repository and update its revision."""
        name, repo_info = repo_data
        async with self.semaphore:
            revision, exit_code = await self.get_head_revision(repo_info["url"])
            
            if exit_code != 0:
                self.returncode = exit_code
            else:
                # Update the revision in the repo info
                repo_info["rev"] = revision
            
            self.update_progress()
            return name, repo_info
    
    async def check_repositories(self, repos: List[Tuple[str, Dict[str, Any]]]) -> List[Tuple[str, Dict[str, Any]]]:
        """Check all repositories concurrently."""
        self.total_count = len(repos)
        
        tasks = [self.check_single_repo(repo_data) for repo_data in repos]
        results = await asyncio.gather(*tasks)
        
        return results


async def main():
    if len(sys.argv) != 2:
        print("Usage: python checkgit.py <config_file.toml>", file=sys.stderr)
        sys.exit(1)
    
    config_file_path = sys.argv[1]
    
    try:
        with open(config_file_path, "rb") as f:
            repos = list(tomllib.load(f).items())
    except FileNotFoundError:
        print(f"Configuration file not found: {config_file_path}", file=sys.stderr)
        sys.exit(1)
    except tomllib.TOMLDecodeError as e:
        print(f"Error parsing TOML file: {e}", file=sys.stderr)
        sys.exit(1)
    
    checker = GitChecker()
    results = await checker.check_repositories(repos)
    
    # Print results as JSON
    print(json.dumps(results))
    sys.exit(checker.returncode)


if __name__ == "__main__":
    asyncio.run(main())
