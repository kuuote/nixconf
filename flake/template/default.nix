{
  flake = {
    templates = rec {
      default = develop;
      develop = {
        description = "devShellテンプレ";
        path = ./develop;
      };
    };
  };
}
