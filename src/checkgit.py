import asyncio
import json
import os
import re
import subprocess
import sys
import tomllib

returncode = 0

terminal_size = os.get_terminal_size(2)

defs = list(tomllib.load(open(sys.argv[1], "rb")).items())

semaphore = asyncio.Semaphore(5)

count = 0


def progress(max):
    global count
    count += 1
    cols = terminal_size.columns - 2
    filled = int((cols) / max * count)
    empty = cols - filled
    print("[" + ("=" * filled) + (" " * empty) + "]", end="\r", file=sys.stderr)
    if count == max:
        print(file=sys.stderr)


async def check(nr):
    async with semaphore:
        d = defs[nr]
        proc = await asyncio.create_subprocess_exec(
            "git",
            "ls-remote",
            d[1]["url"],
            "HEAD",
            stdout=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await proc.communicate()
        if proc.returncode == 0:
            rev = re.sub(r"\s.*", "", stdout.decode())
            d[1]["rev"] = rev
        else:
            global returncode
            returncode = proc.returncode
        progress(len(defs))


async def main():
    tasks = [check(nr) for nr in range(len(defs))]
    await asyncio.gather(*tasks)


asyncio.run(main())
print(json.dumps(defs))
exit(returncode)
