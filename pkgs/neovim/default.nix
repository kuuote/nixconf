{
  callPackage,
  cmake,
  gettext,
  lib,
  linkFarm,
  neovim-src,
  stdenv,
}:
let
  deps = callPackage ./deps.nix { inherit neovim-src; };
in
stdenv.mkDerivation {
  name = "neovim";
  src = neovim-src;
  buildInputs = [
    cmake
    gettext
  ];
  postPatch = ''
    cp -a ${deps} .deps
    chmod -R +w .deps
  '';
  # installPhaseでもビルド走るのでbuildPhaseを潰す
  buildPhase = "true";
}
