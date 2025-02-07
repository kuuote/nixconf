{
  pkgs ? null,
  fetchTree ? pkgs == null,
}:
builtins.mapAttrs (
  if fetchTree then
    (
      _: def:
      builtins.fetchTree {
        inherit (def) owner repo rev;
        narHash = def.hash;
        type = "github";
      }
    )
  else
    (_: def: pkgs.fetchFromGitHub def)
) (builtins.fromJSON (builtins.readFile ./github.lock))
