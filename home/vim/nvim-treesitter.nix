{
  pkgs,
  ...
}:
let
  plug = pkgs.vimPlugins;
  nvim-treesitter = pkgs.symlinkJoin {
    name = "nvim-treesitter";
    paths = [ plug.nvim-treesitter ] ++ plug.nvim-treesitter.withAllGrammars.dependencies;
  };
in
{
  xdg.configFile = {
    "nvim-nix/nvim-treesitter".source = nvim-treesitter;
  };
}
