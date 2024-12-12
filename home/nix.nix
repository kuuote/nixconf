{
  inputs,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    registry = {
      nixpkgs = {
        from = {
          type = "indirect";
          id = "nixpkgs";
        };
        to = {
          type = "path";
          path = "${inputs.nixpkgs.outPath}";
        };
      };
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-derivations = true;
      keep-outputs = true;
    };
  };
}
