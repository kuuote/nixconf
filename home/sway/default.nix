{
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway =
    let
      modifier = "Mod4";
    in
    {
      enable = true;
      config = {
        inherit modifier;
        bars = [
          {
            fonts = {
              names = [
                "JF Dot M+ 12"
              ];
              size = 9.0;
            };
            position = "top";
            statusCommand = "${./status.sh}";
          }
        ];
        defaultWorkspace = "workspace number 1";
        focus = {
          newWindow = "urgent"; # smplayerぶっ叩くのに困るのでswayのデフォルトに合わせておく
          followMouse = false;
        };
        keybindings =
          lib.mkOptionDefault
            {
            };
        output = {
          "*" = {
            bg =
              builtins.fetchurl {
                url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/97444e18b7fe97705e8caedd29ae05e62cb5d4b7/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
                sha256 = "sha256:0ny7393qqbqf54rczyrmy5jyswwi12zrdy7bih2hcq501miqaqky";
              }
              + " fill";
          };
        };
        terminal = "${pkgs.wezterm}/bin/wezterm";
      };
      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile ./extra_config/border.conf)
        (builtins.readFile ./extra_config/notify.conf)
        (import ./extra_config/floaterm)
      ];
    };
}
