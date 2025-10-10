{
  pkgs,
  ...
}:
{
  home.packages = [
    (import ../override/rsync.nix { inherit pkgs; })
  ]
  ++ (with pkgs; [
    # keep-sorted start
    file
    # keep-sorted end
  ]);
}
