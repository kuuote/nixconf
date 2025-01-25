time: {
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=${builtins.toString time}s
  '';
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=${builtins.toString time}s
  '';
}
