{
  pkgs,
  ...
}:
{
  imports = [
    ./sway.nix
  ];
  environment = {
    etc.m.source = pkgs.writeShellScript "mount" ''
      sudo mount -m /dev/disk/by-partlabel/data /data -o subvol=/@
    '';
    systemPackages = [
      pkgs.git
    ];
  };
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  system.installer.channel.enable = false;
}
