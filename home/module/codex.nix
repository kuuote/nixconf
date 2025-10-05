{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Capture the evaluated option values for downstream use.
  cfg = config.kuuote.programs.codex;
in
{
  options.kuuote.programs.codex = {
    enable = lib.mkEnableOption "Codex support within the kuuote namespace.";
    config = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Free-form Codex configuration attributes.";
      example = {
        extraEnv = {
          CODEX_MODE = "interactive";
          CODEX_DEBUG = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    kuuote.postStep =
      let
        cfgFile = cfg.config |> (pkgs.formats.toml { }).generate "codex-config.toml";
      in
      [
        "mkdir -p ~/.codex"
        "rm -f ~/.codex/config.toml"
        "cat ${cfgFile} > ~/.codex/config.toml"
      ];
  };
}
