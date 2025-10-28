{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    blueberry
  ];
  fileSystems."/var/lib/bluetooth" = {
    device = "/nix/user/bluetooth";
    options = [ "bind" ];
  };
  hardware.bluetooth = {
    enable = true;
  };
}
