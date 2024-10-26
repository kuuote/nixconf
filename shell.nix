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
pkgs.mkShellNoCC {
  packages = import ./shellpkgs.nix { inherit home-manager-pkg inputs pkgs; };
}
