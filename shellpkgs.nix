{
  home-manager-pkg,
  inputs,
  pkgs,
}:
let
  # Vimは先っちょをビルドしたい
  vim = import ./override-pkgs/vim.nix {
    pkgs = pkgs.pkgsStatic;
    src = inputs.vim-src;
  };
  neovim = import ./override-pkgs/neovim.nix {
    pkgs = pkgs;
    src = inputs.neovim-src;
  };
in
with pkgs;
[
  deno
  ffmpeg
  home-manager-pkg
  neovim
  nixfmt-rfc-style
  nvfetcher
  vim
  vimPlugins.vim-themis
]
