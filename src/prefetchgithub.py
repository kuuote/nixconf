import json
import re
import subprocess
import sys

defs = json.loads(open(sys.argv[1]).read())
try:
    lock = json.loads(open(sys.argv[2]).read())
    # check values
    for v in lock.values():
        _ = v["rev"]
except:
    lock = {}

githubre = re.compile(r"https://github.com/([^/]+)/([^/]+)")

for d in defs:
    match = githubre.match(d[1]["url"])
    if not match:
        continue
    github = match.group(0)
    owner = match.group(1)
    repo = match.group(2)
    name = d[0]
    rev = d[1]["rev"]
    locked = lock.get(name, {"rev": ""})
    if rev == locked["rev"]:
        continue
    url = f"{github}/archive/{rev}.tar.gz"
    print(url)
    proc = subprocess.Popen(
        # ["nix-prefetch-url", "--unpack", "--name", name, url], stdout=subprocess.PIPE
        ["nix-prefetch-url", "--unpack", url],
        stdout=subprocess.PIPE,
    )
    stdout, _ = proc.communicate()
    if proc.returncode != 0:
        continue
    hash = stdout.decode().strip()
    sri = (
        subprocess.run(
            ["nix-hash", "--to-sri", "--type", "sha256", hash], capture_output=True
        )
        .stdout.decode()
        .strip()
    )
    lock[name] = {"name": name, "owner": owner, "repo": repo, "rev": rev, "hash": sri}

json.dump(lock, open(sys.argv[2], "w"), indent="\t", sort_keys=True)
