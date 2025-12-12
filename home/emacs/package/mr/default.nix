{
  pkgs ? import <nixpkgs> { },
}:
pkgs.emacs.pkgs.melpaBuild {
  pname = "mr";
  version = "0";
  src = ./.;
}
