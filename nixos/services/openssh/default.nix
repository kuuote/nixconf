{
  lib,
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;
    extraConfig = ''
      # VMから接続した時に使うやつ
      Match Address 127.0.0.0/16
        AuthorizedKeysFile = ${./id_local.pub}
    '';
    settings = {
      ChallengeResponseAuthentication = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      StrictModes = false; # VM設定の邪魔だしどっちみち邪魔なので解除
    };
  };
}
