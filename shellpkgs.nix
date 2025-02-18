{
  pkgs,
}:
let
  inherit (import ./pkgs/vim.nix { inherit pkgs; })
    vim
    neovim
    ;
in
with pkgs;
[
  ffmpeg
  neovim
  nix-output-monitor
  nixfmt-rfc-style
  nvfetcher
  vim
  vimPlugins.vim-themis
]
