{
  config,
  lib,
  pkgs,
  ...
}:

# Codexに作ってもらった
# home/module/post.nix にhome-managerのモジュールを作成してください。内容は `kuuote.postStep` というリストを与えられるオプションを持ち、以下のように展開します
# { config, lib, pkgs, ... }:
#
# {
#   home.activation = {
#     myPostStep = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#       # 与えられた内容のリストを連結
#     '';
#   };
# }

let
  cfg = config.kuuote.postStep;
in
{
  options.kuuote.postStep = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Commands appended to the post activation step.";
    example = [
      "echo 'Post activation run'"
      "touch /tmp/done"
    ];
  };

  config = lib.mkIf (cfg != [ ]) {
    # Inject user-defined commands after home-manager's writeBoundary phase.
    home.activation.myPostStep = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatStringsSep "\n" cfg}
    '';
  };
}
