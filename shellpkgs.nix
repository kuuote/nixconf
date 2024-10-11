{
  home-manager,
  inputs,
  pkgs,
}:
let
  # Vimは先っちょをビルドしたい
  vim = import ./override-pkgs/vim.nix {
    pkgs = pkgs;
    src = inputs.vim-src;
  };
  neovim = import ./override-pkgs/neovim.nix {
    pkgs = pkgs;
    src = inputs.neovim-src;
  };
in
with pkgs;
[
  ffmpeg
  home-manager
  neovim
  nixfmt-rfc-style
  vim
  vimPlugins.vim-themis
]
