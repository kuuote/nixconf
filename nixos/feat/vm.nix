{
  lib,
  user,
  pkgs,
  ...
}:
let
  calamares-nixos-autostart = pkgs.makeAutostartItem {
    name = "io.calamares.calamares";
    package = pkgs.calamares-nixos;
  };
in
{
  # vmVariantにあれこれ書いておくとbuild-vmの時だけ使われる
  virtualisation.vmVariant = {
    # hashPasswordFileを使っているので解除した上でユーザー名をそのままパスワードにする
    users.users.${user} = {
      hashedPasswordFile = lib.mkForce null;
      initialPassword = user;
    };
    environment.systemPackages = with pkgs; [
      # Calamares for graphical installation
      libsForQt5.kpmcore
      calamares-nixos
      calamares-nixos-extensions
      calamares-nixos-autostart
      # Get list of locales
      glibcLocales
    ];
    environment.pathsToLink = [
      "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
    ];
    virtualisation.diskSize = 20480;
  };
}
