{
  pkgs,
  ...
}:
{
  nix = {
    nixPath = [
      "nixpkgs=flake"
      "nixpkgs"
    ];
    package = pkgs.nix;
    registry = {
      nixpkgs = {
        from = {
          type = "indirect";
          id = "nixpkgs";
        };
        to = {
          type = "path";
          # pkgs.pathそのまま使うと謎のコピーが走るのでbuiltins.toStringかける
          path = "${builtins.toString pkgs.path}";
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
