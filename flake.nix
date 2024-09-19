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
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        latitude = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./latitude
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alice = {
                home.username = "alice";
                home.homeDirectory = "/home/alice";
                home.stateVersion = "24.05";
                programs.emacs.enable = true;
              };
            }
          ];
        };
      };
      # for debug
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/mycmds { };
    };
}
