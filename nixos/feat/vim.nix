{
  inputs,
  pkgs,
  ...
}:
let
  # Vimは先っちょをビルドしたい
  vim = import ../../override-pkgs/vim.nix {
    pkgs = pkgs;
    src = inputs.vim-src;
  };
  neovim = import ../../override-pkgs/neovim.nix {
    pkgs = pkgs;
    src = inputs.neovim-src;
  };
in
{
  environment = {
    systemPackages = [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      vim
      neovim
      # テストは大事
      pkgs.vimPlugins.vim-themis
    ];
    variables = {
      # Vimは真理
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };
}
