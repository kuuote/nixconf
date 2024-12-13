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
          followMouse = false;
          mouseWarping = "container";
          newWindow = "urgent"; # smplayerぶっ叩くのに困るのでswayのデフォルトに合わせておく
        };
        keybindings = lib.mkOptionDefault {
        };
        output = {
          "*" = {
            bg =
              let
                # bgFile = builtins.fetchurl {
                #   url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/da01f68d21ddfdc9f1c6e520c2170871c81f1cf5/wallpapers/nix-wallpaper-nineish.png";
                #   sha256 = "sha256:1mwvnmflp0z1biyyhfz7mjn7i1nna94n7jyns3na2shbfkaq7i0h";
                # };
                name = "nineish";
                bgPath = "${
                  pkgs.nixos-artwork.wallpapers.${name}
                }/share/backgrounds/nixos/nix-wallpaper-${name}.png";
              in
              "${bgPath} fill";
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
