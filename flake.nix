{
  description = "俺の城";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vim-src = {
      url = "github:vim/vim/";
      flake = false;
    };
    neovim-src = {
      url = "github:neovim/neovim/";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      vim-src,
      neovim-src,
    }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        latitude = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit vim-src neovim-src;
          };
          modules = [
            ./latitude
          ];
        };
      };
    };
}
