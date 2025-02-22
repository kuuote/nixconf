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
  home = {
    packages = [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      vim
      neovim
      # テストは大事
      pkgs.vimPlugins.vim-themis
    ];
    sessionVariables = {
      # Vimは真理
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };
  imports = [
    # keep-sorted start
    ./deno-pty-ffi.nix
    ./nvim-treesitter.nix
    # keep-sorted end
  ];
}
