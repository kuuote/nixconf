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
    # keep-sorted start
    ./abbr/deno.nix
    ./abbr/fish.nix
    ./abbr/git.nix
    ./abbr/misc.nix
    ./abbr/nix.nix
    ./abbr/tmux.nix
    ./abbr/trash-cli.nix
    ./abbr/vim.nix
    # keep-sorted end
  ] args;
  programs.fish.shellInit = builtins.concatStringsSep "\n" ([
    # 強制的にsessionVariablesをリロードする
    ''
      set -gu __HM_SESS_VARS_SOURCED
      source (grep -o '/nix/store/.*hm-session-vars.fish$' (status current-filename))
    ''
    (import ./init/mru.nix { inherit pkgs; })
    (import ./init/external-chdir.nix)
    "fish_add_path ~/cmd"
    "fish_add_path ~/.nix-profile/bin"
  ]);
  programs.fish.interactiveShellInit = "echo in ${
    if args ? "nixosConfig" then "NixOS" else "Standalone"
  }";
}
