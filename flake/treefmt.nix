{
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        # keep-sorted start
        black.enable = true;
        keep-sorted.enable = true;
        nixfmt.enable = true;
        rustfmt.enable = true;
        # keep-sorted end
      };
    };
  };
}
