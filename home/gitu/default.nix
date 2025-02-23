{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.gitu ];
  xdg.configFile = {
    "gitu/config.toml".source = ./config.toml;
  };
}
