{
  description = "べんり";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          fish
          hello
        ];
        shellHook = ''
          exec fish
        '';
      };
    };
}
