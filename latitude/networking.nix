{
  # Pick only one of the below networking options.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.secretsFile = "/data/nix-secrets/wireless.conf";
  networking.wireless.networks = {
    "Buffalo-G-230E" = {
      pskRaw = "ext:psk_buffalo";
    };
  };
  networking.wireless.userControlled.enable = true;
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
}
