{
  pkgs,
  ...
}:
{
  environment = {
    etc = {
      "sway/config".text =
        let
          bgFile = builtins.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/da01f68d21ddfdc9f1c6e520c2170871c81f1cf5/wallpapers/nix-wallpaper-nineish.png";
            sha256 = "sha256:1mwvnmflp0z1biyyhfz7mjn7i1nna94n7jyns3na2shbfkaq7i0h";
          };
        in
        ''
          include ${pkgs.sway}/etc/sway/config
          output * bg ${bgFile} fill
        '';
    };
    systemPackages = [
      pkgs.sway
    ];
  };
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Noto Sans Mono CJK JP"
        ];
      };
      enable = true; # イメージ定義の方で無効化されているので改めて入れる
    };
    packages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
  programs.foot = {
    enable = true;
    settings = {
      colors.alpha = 0.7;
    };
  };
  security.polkit.enable = true;
  services.graphical-desktop.enable = true;
}
