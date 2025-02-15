{
  home-manager-pkg,
  inputs,
  pkgs,
}:
let
  inherit
    (import ./pkgs/vim.nix {
      inherit pkgs;
      inherit (inputs) vim-src neovim-src;
    })
    vim
    neovim
    ;
in
with pkgs;
[
  ffmpeg
  home-manager-pkg
  neovim
  nix-output-monitor
  nixfmt-rfc-style
  nvfetcher
  vim
  vimPlugins.vim-themis
]
