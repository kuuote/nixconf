{
  # Pick only one of the below networking options.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.environmentFile = "/data/nix-secrets/wireless.env";
  networking.wireless.networks = {
    "Buffalo-A-230E" = {
      psk = "@PSK_BUFFALO@";
    };
  };
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
}
