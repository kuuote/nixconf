{
  pkgs,
  lib,
  ...
}:
{
  kuuote.programs.codex = {
    enable = true;
    config = {
      features = {
        web_search_request = true;
      };
      network_access = true;
    };
  };
}
