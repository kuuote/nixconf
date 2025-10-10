{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    # keep-sorted start
    (import ../override/rsync.nix { inherit pkgs; })
    inputs.self.packages.${pkgs.system}.nixshell
    # keep-sorted end
  ]
  ++ (with pkgs; [
    # keep-sorted start
    file
    # keep-sorted end
  ]);
}
