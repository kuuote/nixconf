{
  pkgs,
  inputs,
  ...
}:
{
  xdg.configFile = {
    "home-manager/inputs".source = pkgs.linkFarm "inputs" inputs;
  };
}
