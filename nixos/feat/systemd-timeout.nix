time: {
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "${builtins.toString time}s";
  };
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=${builtins.toString time}s
  '';
}
