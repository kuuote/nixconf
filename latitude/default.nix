# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:

let

  #networking = import ../nixos/networking.nix { hostName = "nixos"; };
  boot = import ../nixos/boot.nix;
  networking_wireless = import ../nixos/networking/wireless.nix;
  nix = import ../nixos/nix.nix;
  openssh = import ../nixos/services/openssh;

  jfdotfont = pkgs.callPackage ../pkgs/jfdotfont { };
  mycmds = pkgs.callPackage ../pkgs/mycmds { };
in
{
  imports = [
    (import ../nixos/feat/vim.nix { inherit inputs pkgs; })
    (import ../nixos/feat/xremap.nix { inherit pkgs; })
    (import ../nixos/services/openssh { usePassword = true; })
    ../nixos/feat/acpilight.nix
    boot
    networking_wireless
    nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "input" # for xremap
      "uinput" # for xremap
      "wheel" # Enable ‘sudo’ for the user.
    ];
    hashedPassword = "$y$j9T$G7oFPasBuVL1NcN3wPu0A/$uNAIdrXb4Kw2RO1s4/BSKpNBTBlywVUHU8wQXfIduz9";
    packages = with pkgs; [
      firefox
      fish
      mpv
      mycmds
      smplayer
      tree
    ];
    shell = pkgs.fish;
  };
  services.getty.autologinUser = user;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    btrfs-progs
    cryptsetup
    deno
    dunst
    fd
    ffmpeg
    fzf
    gcc
    git
    gnumake
    lua
    ncurses
    nixfmt-rfc-style
    noto-fonts-cjk-sans
    python3
    ripgrep
    tmux
    trash-cli
    unar
    vifm
    wezterm
    wget
    wineWow64Packages.full
    # sway
    grim
    slurp
    sway-contrib.grimshot
    wf-recorder
    wl-clipboard
    wofi
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

  programs.sway = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
