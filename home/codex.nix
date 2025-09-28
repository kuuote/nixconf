{
  pkgs,
  lib,
  ...
}:
let
  cfg =
    {
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
    }
    |> (pkgs.formats.toml { }).generate "codex-config.toml";
in
{
  kuuote.postStep = [
    "mkdir -p ~/.codex"
    "rm -f ~/.codex/config.toml"
    "cat ${cfg} > ~/.codex/config.toml"
  ];
}
