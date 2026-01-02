{
  # Pick only one of the below networking options.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.secretsFile = "/data/nix-secrets/wireless.conf";
  networking.wireless.networks = {
    "NSD1K-7EC0-g" = {
      pskRaw = "ext:psk_nsd1k";
    };
  };
  networking.wireless.userControlled = true;
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
}
