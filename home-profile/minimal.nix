# minimal and impure configuration
{
  user = builtins.getEnv "USER";
  modules = [
    ../home/base.nix
    ../home/linux.nix

    ../home/deno.nix
    ../home/fish
    ../home/git
    ../home/nix.nix
    ../home/vars.nix
  ];
}
