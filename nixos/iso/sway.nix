{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.foot
    pkgs.sway
  ];
  security.polkit.enable = true;
  services.graphical-desktop.enable = true;
}
