// length first sort
function sorter(a: string, b: string): number {
  return a.length - b.length || a.localeCompare(b);
}

async function readdirdir(path: string): Promise<string[]> {
  const dirs = [];
  for await (const e of Deno.readDir(path)) {
    if (e.isDirectory) {
      dirs.push(`${path}/${e.name}`);
    }
  }
  return dirs.sort(sorter);
}

async function process(remain: string[]) {
  let pos = 0;
  while (pos < remain.length) {
    const dir = remain[pos++];
    console.log(dir);
    try {
      remain.push(...await readdirdir(dir));
    } catch {
      continue;
    }
  }
}

const es = Array.from(Deno.readDirSync(".")).filter((e) => e.isDirectory).map(
  (e) => e.name
).sort(sorter);
await process(es);
