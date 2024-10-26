{
  programs.git = {
    enable = true;
    aliases = {
      save = "!git add -A ; git commit -m save ; git tag -f save";
    };
    extraConfig = {
      commit.verbose = true;
      core = {
        editor = "vim";
        quotepath = false;
      };
      diff.algorithm = "histogram";
      fetch.prune = true;
      init.defaultBranch = "main";
      push.default = "current";
      user = {
        email = "znmxodq1@gmail.com";
        name = "kuuote";
      };
    };
  };
}
