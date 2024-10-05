{
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
  neovim
  nixfmt-rfc-style
  vim
  (inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default)
]
