{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.sway-contrib.grimshot
  ];
  programs.sway.enable = true;
}
