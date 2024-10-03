{
  lib,
  pkgs,
  ...
}@args:
let
  inherit (import ../../lib/merge-attrs.nix)
    importAttrs
    mergeAttrs
    ;
in
{
  programs.fish.enable = true;
  programs.fish.functions = mergeAttrs [
    (import ./functions/chdir.nix)
    # (import ./functions/mru.nix { inherit pkgs; })
    {
      # nix shell使うとネストするのでネスト数を出す
      fish_right_prompt = ''
        set -l fish_count (ps | grep fish | wc -l)
        if test "$fish_count" -ne 1;
          echo "[$fish_count]"
        end
      '';
    }
  ];
  programs.fish.shellAbbrs = importAttrs [
    ./abbr/deno.nix
    ./abbr/fish.nix
    ./abbr/nix.nix
    ./abbr/tmux.nix
    ./abbr/trash-cli.nix
    ./abbr/vim.nix
  ] args;
  programs.fish.shellInit = builtins.concatStringsSep "\n" ([
    (import ./init/mru.nix { inherit pkgs; })
    "fish_add_path ~/cmd"
  ]);
}
