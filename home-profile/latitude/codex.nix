{
  pkgs,
  lib,
  ...
}:
{
  # sh -cしておかないとCodexが渡してくる引数(JSON)により死ぬ
  kuuote.programs.codex.config.notify =
    let
      exe = lib.mapAttrs (_: lib.getExe) pkgs;
    in
    [
      (exe.bashInteractive)
      "-c"
      # "nix shell nixpkgs#alacritty nixpkgs#figlet nixpkgs#fish --command alacritty -e fish -C 'figlet codex notify'"
      "${exe.alacritty} -e ${exe.fish} -C '${exe.figlet} codex notify'"
    ];
}
