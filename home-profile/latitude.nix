{
  user = "alice";
  modules = [
    ../home/base.nix
    ../home/linux.nix
    ./latitude/codex.nix
  ]
  ++ (import ./full.nix)
  ++ (import ./full-gui.nix);
}
