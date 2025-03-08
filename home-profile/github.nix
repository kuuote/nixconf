{
  user = "runner";
  modules = [
    ../home/base.nix
    ../home/linux.nix
    # keep-sorted start
    ../home/git
    ../home/nix.nix
    ../home/vars.nix
    ../home/vim
    # keep-sorted end
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.nix-output-monitor ];
        home.sessionVariables.LANG = "en_US.UTF-8";
      }
    )
  ];
}
