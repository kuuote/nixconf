# minimal configuration
# 置換して運用する前提でユーザーはプレースホルダにしてる
{
  user = "@user@";
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
