let
  locked = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
in
builtins.fetchTarball {
  name = "source";
  url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
  sha256 = locked.narHash;
}
