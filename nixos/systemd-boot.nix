{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    # /boot溢れを防ぐためにエントリの数を制限する
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
