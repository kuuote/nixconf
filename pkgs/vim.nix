{
  pkgs,
}:
let
  src = import ../src { inherit pkgs; };
  vim-src = src.vim;
  neovim-src = src.neovim;
in
{
  # Vimは先っちょをビルドしたい
  vim = pkgs.callPackage ./vim { inherit pkgs vim-src; };
  neovim = pkgs.callPackage ./neovim { inherit pkgs neovim-src; };
}
