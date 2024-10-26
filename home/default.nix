{
  user,
  ...
}:
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.05";
  imports = [
    ./emacs
    ./fish
    ./sway
    ./wezterm
  ];
}
