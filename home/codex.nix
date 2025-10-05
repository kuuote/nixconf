{
  pkgs,
  lib,
  ...
}:
{
  kuuote.programs.codex = {
    enable = true;
    config = {
      network_access = true;
      # sh -cしておかないとCodexが渡してくる引数(JSON)により死ぬ
      notify = [
        (lib.getExe pkgs.bashInteractive)
        "-c"
        "nix shell nixpkgs#alacritty nixpkgs#figlet nixpkgs#fish --command alacritty -e fish -C 'figlet codex notify'"
      ];
      tools = {
        web_search = true;
      };
    };
  };
}
