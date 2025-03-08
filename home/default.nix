{
  lib,
  user,
  isNixOSHost,
  ...
}@args:
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.05";
  imports =
    [
      # keep-sorted start
      ./cmd
      ./deno.nix
      ./direnv.nix
      ./emacs
      ./fish
      ./git
      ./gitu
      ./inputs.nix
      ./nix.nix
      ./pkgs.nix
      ./vars.nix
      ./vim
      # keep-sorted end
    ]
    ++ lib.optionals isNixOSHost [
      ./sway
      ./wezterm
    ];
}
