{
  home-manager-pkg,
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
  deno
  ffmpeg
  home-manager-pkg
  neovim
  nix-output-monitor
  nixfmt-rfc-style
  nvfetcher
  vim
  vimPlugins.vim-themis
]
