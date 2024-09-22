{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.alice = {
    home.username = "alice";
    home.homeDirectory = "/home/alice";
    home.stateVersion = "24.05";
    programs.emacs.enable = true;
    imports = [
      ./fish
    ];
  };
}
