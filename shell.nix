{
  home-manager-pkg,
  inputs,
  pkgs,
}:
pkgs.mkShellNoCC {
  packages = import ./shellpkgs.nix { inherit home-manager-pkg inputs pkgs; };
}
