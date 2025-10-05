{
  lib,
  user,
  isNixOSHost,
  ...
}@args:
{
  home.username = user;
  home.stateVersion = "25.05";
  imports = [
    ./module/codex.nix
    ./module/post.nix
  ];
}
