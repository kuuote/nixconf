# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  vim-src,
  neovim-src,
  ...
}:

let

  #networking = import ../nixos/networking.nix { hostName = "nixos"; };
  boot = import ../nixos/boot.nix;
  networking_wireless = import ../nixos/networking/wireless.nix;
  nix = import ../nixos/nix.nix;
  openssh = import ../nixos/services/openssh.nix;

  jfdotfont = pkgs.callPackage ../pkgs/jf-dotfont { };
in
{
  imports = [
    boot
    networking_wireless
    nix
    openssh
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
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$G7oFPasBuVL1NcN3wPu0A/$uNAIdrXb4Kw2RO1s4/BSKpNBTBlywVUHU8wQXfIduz9";
    packages = with pkgs; [
      firefox
      fish
      libreoffice-fresh
      mpv
      smplayer
      tree
    ];
    shell = pkgs.fish;
  };

  nixpkgs.overlays = [
    (final: prev: {
      vim2 = prev.vim.overrideAttrs (oldAttrs: {
        version = "latest";
        src = vim-src;
        configureFlags = oldAttrs.configureFlags ++ [
          "--enable-luainterp"
          "--with-lua-prefix=${prev.lua}"
          "--enable-fail-if-missing"
        ];
        buildInputs = oldAttrs.buildInputs ++ [ prev.lua ];
      });
    })
    (final: prev: rec {
      utf8proc-latest = prev.utf8proc.overrideAttrs {
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = "JuliaStrings";
          repo = "utf8proc";
          rev = "3de4596fbe28956855df2ecb3c11c0bbc3535838";
          sha256 = "sha256-DNnrKLwks3hP83K56Yjh9P3cVbivzssblKIx4M/RKqw=";
        };
      };
      neovim-latest = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
        version = "latest";
        src = neovim-src;
        buildInputs = oldAttrs.buildInputs ++ [ utf8proc-latest ];
      });
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    btrfs-progs
    deno
    dunst
    fd
    fzf
    gcc
    git
    gnumake
    lua
    ncurses
    neovim-latest
    nixfmt-rfc-style
    noto-fonts-cjk
    python3
    ripgrep
    tmux
    trash-cli
    unar
    vifm
    vim2 # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wezterm
    wget
    # sway
    grim
    mako
    slurp
    sway-contrib.grimshot
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
