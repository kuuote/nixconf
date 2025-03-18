{
  programs.direnv = {
    enable = true;
    config = {
      disable_stdin = true;
      strict_env = true;
      warn_timeout = 0;
    };
    nix-direnv.enable = true;
  };
  programs.git = {
    ignores = [
      ".direnv"
      ".envrc"
    ];
  };
  xdg.configFile = {
    "direnv/direnvrc".source = ./direnvrc;
    "direnv/rc".source = ./rc;
  };
}
