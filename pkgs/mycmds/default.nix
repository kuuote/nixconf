{
  fetchurl,
  pkgs,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  allowSubstitutes = false;
  name = "mycmds";
  src = ./mycmds;
  installPhase = ''
    install -m555 -Dt $out/bin $src/*
  '';
}
