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
      tools = {
        web_search = true;
      };
    };
  };
}
