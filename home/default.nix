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
    ./deno.nix
    ./direnv.nix
    ./emacs
    ./fish
    ./git
    ./nix.nix
    ./nvim-nix
    ./sway
    ./wezterm
    # keep-sorted end
  ];
}
