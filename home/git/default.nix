{
  programs.git = {
    enable = true;
    settings = {
      alias = {
        save = "!git add -A ; git commit -m save ; git tag -f save";
      };
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
