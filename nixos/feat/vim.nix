{
  inputs,
  pkgs,
  ...
}:
let
  inherit
    (import ../../pkgs/vim.nix {
      inherit pkgs;
    })
    vim
    neovim
    ;
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
