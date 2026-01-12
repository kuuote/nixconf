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
  jfdotfont = pkgs.callPackage ../pkgs/jfdotfont { };
  mycmds = pkgs.callPackage ../pkgs/mycmds { };
in
{
  imports = [
    # keep-sorted start
    (import ../nixos/feat/systemd-timeout.nix 10)
    (import ../nixos/services/openssh { usePassword = true; })
    ../nixos/feat/acpilight.nix
    ../nixos/feat/bluetooth.nix
    ../nixos/feat/nixos-apply/module.nix
    ../nixos/feat/vm.nix
    ../nixos/keyd.nix
    ../nixos/nix-ld.nix
    ../nixos/nix.nix
    ../nixos/sway.nix
    ../nixos/systemd-boot.nix
    ./networking.nix
    ./test.nix
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
  users.users.root.hashedPassword = "$y$j9T$r2hDb1.weG.kmkAkWL0nc/$e7p1/YFoLVfjhE7XJJCUS5Yt4hcpoHKr1HdyHQnA0z7";
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
    dunst
    fd
    ffmpeg
    fzf
    git
    jq
    keepassxc
    meld
    nix-output-monitor
    nixfmt
    nsxiv
    python3
    ripgrep
    stylua
    tmux
    trash-cli
    unar
    vifm
    wezterm
    wineWow64Packages.full
    zellij
    # keep-sorted end
    # sway
    grim
    slurp
    wf-recorder
    wl-clipboard
  ];

  fonts = {
    packages = with pkgs; [
      # keep-sorted start
      ibm-plex
      jfdotfont
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      plemoljp
      # keep-sorted end
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
  zramSwap.enable = true;
  programs.gnupg.agent.enable = true;
}
