{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.callPackage ./. { })
  ];
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-apply";
          options = [
            "SETENV"
            "NOPASSWD"
          ];
        }
      ];
    }
  ];
}
