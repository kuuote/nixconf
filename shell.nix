{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = import ./shellpkgs.nix { inherit pkgs; };
}
