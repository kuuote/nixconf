{
  user = "arch";
  modules = [
    ../home/base.nix
    ../home/linux.nix
  ] ++ (import ./full.nix);
}
