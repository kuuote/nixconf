# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  host,
  user,
  ...
}:

let
  pkgset = { inherit pkgs; };
  deno2nix = (import (import ../src { }).deno2nix pkgset).deno2nix;
  jfdotfont = pkgs.callPackage ../pkgs/jfdotfont { };
  mycmds = pkgs.callPackage ../pkgs/mycmds { };
in
{
  imports = [
    # keep-sorted start
    (import ../nixos/feat/systemd-timeout.nix 10)
    (import ../nixos/services/openssh { usePassword = true; })
    ../nixos/feat/acpilight.nix
    ../nixos/feat/nixos-apply/module.nix
    ../nixos/feat/vm.nix
    ../nixos/nix.nix
    ../nixos/sway.nix
    ../nixos/systemd-boot.nix
    ../nixos/user/xremap.nix
    ./networking.nix
    # keep-sorted end
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = host; # Define your hostname.

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
    ];
    hashedPasswordFile = "/nix/secret/${user}.passwd";
    packages = with pkgs; [
      firefox
      mpv
      mycmds
      smplayer
    ];
    shell = pkgs.fish;
  };
  services.getty.autologinUser = user;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    acpi
    alacritty
    btrfs-progs
    chromium
    deno2nix
    dunst
    fd
    ffmpeg
    fzf
    git
    jq
    nix-output-monitor
    nixfmt-rfc-style
    nsxiv
    python3
    ripgrep
    stylua
    tmux
    trash-cli
    vifm
    wezterm
    wineWow64Packages.full
    # keep-sorted end
    # sway
    grim
    slurp
    wf-recorder
    wl-clipboard
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      jfdotfont
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "Noto Sans Mono CJK JP"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
