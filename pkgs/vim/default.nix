{
  lib,
  pkgs,
  vim-src,
  luaSupport ? true,
}:
let
  moldStdenv = pkgs.useMoldLinker pkgs.clangStdenv;
  inherit (import ../../lib/merge-attrs.nix) mergeAttrs;
in
moldStdenv.mkDerivation (mergeAttrs [
  {
    name = "vim";
    version = "head";
    src = vim-src;
    nativeBuildInputs = [ pkgs.ncurses ];
    hardeningDisable = [ "fortify" ];
    enableParallelBuilding = true;
    configureFlags = [ "--enable-fail-if-missing" ];
  }
  (
    if luaSupport then
      {
        configureFlags = [
          "--enable-luainterp"
          "--with-lua-prefix=${pkgs.lua}"
        ];
      }
    else
      { }
  )
])
