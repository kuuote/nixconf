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
        inputs = pkgs.linkFarm "inputs" (builtins.mapAttrs (name: builtins.toString) inputs);
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # keep-sorted start
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
            let
              config =
                {
                  extraModules ? [ ],
                  host,
                  user,
                }:
                {
                  "${host}@${user}" = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = specialArgsBase // {
                      inherit host user;
                      isNixOSHost = builtins.elem host [
                        "192"
                      ];
                    };
                    modules = [
                      ./home
                    ] ++ extraModules;
                  };
                };
            in
            lib.pipe
              [
                {
                  host = "192";
                  user = "alice";
                }
                {
                  host = "42";
                  user = "arch";
                  extraModules = [
                    {
                      home.packages = import ./shellpkgs.nix { inherit pkgs; };
                    }
                  ];
                }
              ]
              [
                (map config)
                lib.mergeAttrsList
              ];
          nixosConfigurations = {
            iso = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
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
                  # inputsへのrefもあると便利そう
                  environment.etc.inputs.source = (packages pkgs).inputs;
                }
              ];
              specialArgs = specialArgsBase // {
                host = "192";
                user = "alice";
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
          };
          packages = rec {
            links = pkgs.linkFarm "links" {
              inputs = (packages pkgs).inputs;
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
