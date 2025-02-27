{
  description = "べんり";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem =
        fn: lib.genAttrs lib.systems.flakeExposed (system: fn nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = import ./shell.nix { inherit pkgs; };
      });
      packages = eachSystem (pkgs: {
        default = import ./default.nix { inherit pkgs; };
      });
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
}
