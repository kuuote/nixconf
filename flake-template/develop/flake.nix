{
  description = "べんり";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      # flake-parts replica
      perSystem =
        fn:
        let
          eached = lib.genAttrs lib.systems.flakeExposed (system: fn nixpkgs.legacyPackages.${system});
        in
        lib.pipe eached [
          (lib.mapAttrsToList (system: builtins.mapAttrs (name: value: { "${system}" = value; })))
          (builtins.foldl' lib.recursiveUpdate { })
        ];
    in
    perSystem (pkgs: {
      devShells = rec {
        default = shell;
        shell = pkgs.mkShell {
          packages = [ pkgs.fish ];
          shellHook = "exec fish";
        };
      };
      packages = {
        default = pkgs.writeShellScript "test" "echo 42";
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
}
