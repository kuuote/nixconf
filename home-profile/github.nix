{
  user = "runner";
  modules = [
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
        home.sessionVariables.LANG = "en-US.UTF-8";
      }
    )
  ];
}
