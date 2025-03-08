{
  user = "alice";
  modules =
    [
      ../home/base.nix
      ../home/linux.nix
    ]
    ++ (import ./full.nix)
    ++ (import ./full-gui.nix);
}
