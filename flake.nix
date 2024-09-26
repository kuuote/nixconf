{
  description = "俺の城";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-src.flake = false;
    neovim-src.url = "github:neovim/neovim";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vim-src.flake = false;
    vim-src.url = "github:vim/vim";
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      nixosConfigurations = {
        latitude = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./latitude
            home-manager.nixosModules.home-manager
            ./home
          ];
        };
      };
      # for debug
      packages.${system}.default = pkgs.callPackage ./pkgs/mycmds { };
    };
}
