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
  # keep-sorted start
  ffmpeg
  neovim
  nix-output-monitor
  nix-serve-ng
  nixfmt
  nvfetcher
  vim
  vimPlugins.vim-themis
  # keep-sorted end
]
