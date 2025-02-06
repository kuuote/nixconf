{
  description = "べんり";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      eachPkgs =
        fn:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: fn nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachPkgs (pkgs: rec {
        default = shell;
        shell = pkgs.mkShell {
          packages = [ pkgs.fish ];
          shellHook = "exec fish";
        };
      });
      packages = eachPkgs (pkgs: {
        default = pkgs.writeScript "test" "echo 42";
      });
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
}
