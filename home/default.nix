{
  user,
  ...
}:
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.05";
  imports = [
    # keep-sorted start
    ./emacs
    ./fish
    ./git
    ./nvim-nix
    ./sway
    ./wezterm
    # keep-sorted end
  ];
}
