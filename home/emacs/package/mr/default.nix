{
  pkgs ? import <nixpkgs> { },
}:
pkgs.emacsPackages.melpaBuild {
  pname = "mr";
  version = "0";
  src = ./.;
}
