{
  pkgs,
  inputs,
  ...
}:
{
  xdg.configFile = {
    "hm/inputs".source = pkgs.linkFarm "inputs" inputs;
  };
}
