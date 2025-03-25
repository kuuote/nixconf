{
  user = "runner";
  modules = [
    ../home/base.nix
    ../home/linux.nix
    # keep-sorted start
    ../home/cmd
    ../home/emacs-min
    ../home/fish
    ../home/git
    ../home/nix.nix
    ../home/vars.nix
    # keep-sorted end
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.nix-output-monitor ];
      }
    )
  ];
}
