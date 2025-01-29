{
  description = "べんり";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} = rec {
        default = shell;
        shell = pkgs.mkShell {
          packages = with pkgs; [
            fish
            hello
          ];
          shellHook = ''
            exec fish
          '';
        };
      };
      packages.${system} = {
        default = pkgs.writeScript "test" "echo 42";
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
}
