{
  neovim-src,
  pkgs,
}:
let
  deps = pkgs.callPackage ./deps.nix { inherit neovim-src; };
  moldStdenv = pkgs.useMoldLinker pkgs.clangStdenv;
in
moldStdenv.mkDerivation {
  name = "neovim";
  src = neovim-src;
  buildInputs = with pkgs; [
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
