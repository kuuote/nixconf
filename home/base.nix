{
  lib,
  user,
  isNixOSHost,
  ...
}@args:
{
  home.username = user;
  home.stateVersion = "25.05";
}
