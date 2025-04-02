{
  description = "俺の城";

  outputs =
    {
      flake-parts,
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      packages = pkgs: {
        home-manager =
          let
            path = "${inputs.home-manager.outPath}";
            pkg = "${path}/home-manager";
          in
          pkgs.callPackage pkg { inherit path; };
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # keep-sorted start
        ./flake/pkgs
        ./flake/template
        ./flake/treefmt.nix
        # keep-sorted end
      ];
      flake =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
          specialArgsBase = {
            inherit inputs;
          };
        in
        {
          homeConfigurations =
            import ./home-profile
            |> builtins.mapAttrs (
              _:
              { user, modules }:
              home-manager.lib.homeManagerConfiguration {
                inherit pkgs modules;
                extraSpecialArgs = specialArgsBase // {
                  inherit user;
                };
              }
            );
          nixosConfigurations = {
            iso = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                "${inputs.nixpkgs.outPath}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                ./nixos/iso
              ];
            };
            latitude = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./nixos/home-manager.nix
                inputs.nix-index-database.nixosModules.nix-index
                ./latitude
                {
                  # 何かあった時のために現在のビルドソースへのリンクを作っておく
                  environment.etc.c.source = ./.;
                }
              ];
              specialArgs = specialArgsBase // {
                host = "192";
                user = "alice";
                homeManagerModules = (import ./home-profile/latitude.nix).modules;
              };
            };
          };
        };
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          ...
        }:
        {
          devShells = {
            default = import ./shell.nix { inherit pkgs; };
            nix-path = pkgs.mkShell {
              env.NIX_PATH =
                inputs
                |> builtins.mapAttrs (name: value: "${name}=${value.outPath}")
                |> builtins.attrValues
                |> builtins.concatStringsSep ":";
            };
          };
          packages = rec {
            links = pkgs.linkFarm "links" {
              shellpkgs = pkgs.linkFarmFromDrvs "shellpkgs" (import ./shellpkgs.nix { inherit pkgs; });
            };
            default = pkgs.runCommandCC "hoge" { } ''
              mkdir $out
              ln -s ${links} $out/links
              export > $out/export
            '';
          };
        };
    };

  inputs = {
    # keep-sorted start
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    # keep-sorted end
  };
}
