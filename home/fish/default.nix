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
  programs.fish = {
    enable = true;
    functions = mergeAttrs [
      (import ./functions/chdir.nix)
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
    shellAbbrs = importAttrs [
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
    shellInit = builtins.concatStringsSep "\n" ([
      (import ./init/mru.nix { inherit pkgs; })
      (import ./init/external-chdir.nix)
      "fish_add_path ~/cmd"
      "fish_add_path ~/.nix-profile/bin"
    ]);
    interactiveShellInit = "echo in ${if args ? "nixosConfig" then "NixOS" else "Standalone"}";
  };
}
