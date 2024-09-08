{
  description = "俺の城";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vim-src = {
      url = "github:vim/vim/";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, vim-src }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        latitude = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit vim-src;
          };
          modules = [
            ./latitude
          ];
        };
      };
    };
}
