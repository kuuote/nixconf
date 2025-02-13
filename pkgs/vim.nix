{
  pkgs,
  vim-src,
  neovim-src,
}:
{
  # Vimは先っちょをビルドしたい
  vim = pkgs.callPackage ./vim { inherit pkgs vim-src; };
  neovim = pkgs.callPackage ./neovim { inherit pkgs neovim-src; };
}
