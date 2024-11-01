{
  # パスワード系は危険なので切っておく
  usePassword ? false,
}:
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
      ChallengeResponseAuthentication = usePassword;
      KbdInteractiveAuthentication = usePassword;
      PasswordAuthentication = usePassword;
      PermitRootLogin = "no";
      StrictModes = false; # VM設定の邪魔だしどっちみち邪魔なので解除
    };
  };
}
