user: {
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.05";
  programs.emacs.enable = true;
  imports = [
    ./fish
  ];
}
