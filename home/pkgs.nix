{
  pkgs,
  ...
}:
{
  home.packages = [
    (import ../override/rsync.nix { inherit pkgs; })
  ];
}
