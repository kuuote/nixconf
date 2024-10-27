{
  description = "俺の城";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-src.flake = false;
    neovim-src.url = "github:neovim/neovim/c4762b309714897615607f135aab9d7bcc763c4f";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    org-babel.url = "github:emacs-twist/org-babel";
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
      home-manager-pkg =
        let
          path = "${inputs.home-manager}";
          pkg = "${path}/home-manager";
        in
        pkgs.callPackage pkg { inherit path; };
      inputs-pkg = pkgs.stdenvNoCC.mkDerivation {
        name = "inputs-pkg";
        phases = [ "linkPhase" ];
        linkPhase = ''
          mkdir $out
          ln -s ${inputs.home-manager} $out/home-manager
          ln -s ${inputs.nix-index-database} $out/nix-index-database
          ln -s ${inputs.nixpkgs} $out/nixpkgs
          ln -s ${inputs.org-babel} $out/org-babel
        '';
      };
      specialArgs = {
        inherit inputs;
      };
    in
    {
      devShells.${system}.default = import ./shell.nix {
        inherit
          home-manager-pkg
          inputs
          pkgs
          ;
      };
      formatter.${system} = pkgs.nixfmt-rfc-style;
      homeConfigurations =
        let
          config =
            user:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = specialArgs // {
                inherit user;
              };
              modules = [
                ./home
              ];
            };
        in
        {
          alice = config "alice"; # home-manager build用
          arch = config "arch";
        };
      nixosConfigurations = {
        a = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            {
              services.getty.autologinUser = "root";
            }
          ];
        };
        latitude =
          let
            special = specialArgs // {
              user = "alice";
            };
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = special;
            modules = [
              home-manager.nixosModules.home-manager
              { home-manager.extraSpecialArgs = special; }
              ./home/nixos.nix
              inputs.nix-index-database.nixosModules.nix-index
              ./latitude
              {
                # 何かあった時のために現在のビルドソースへのリンクを作っておく
                environment.etc.c.source = ./.;
                # inputsへのrefもあると便利そう
                environment.etc.inputs.source = inputs-pkg;
              }
            ];
          };
      };
      # for debug
      # packages.${system}.default = pkgs.callPackage ./pkgs/mycmds { };
      packages.${system} = {
        default = pkgs.stdenvNoCC.mkDerivation {
          name = "test";
          srcs = import ./shellpkgs.nix {
            inherit
              home-manager-pkg
              inputs
              pkgs
              ;
          };
          inputs = builtins.attrValues inputs;
          phases = [ "linkPhase" ];
          linkPhase = ''
            for src in $srcs; do
              mkdir -p $out/bin
              for bin in $src/bin/*; do
                ln -s $bin $out/bin/
              done
              # srcへのリンクを作っておく。hashはいらないので除去
              ln -s $src $out/$(echo $src | sed -E 's|.*/nix/store/.{32}-||g')
            done
            # 依存関係をGC対象から外すおまじない
            export > $out/export.txt
            # こちらでもinputsの参照をできるようにしておく
            ln -s ${inputs-pkg} $out/inputs
          '';
        };
        home-manager = home-manager-pkg;
      };
      templates = rec {
        default = develop;
        develop = {
          description = "devShellテンプレ";
          path = ./flake-template/develop;
        };
      };
      z = import ./lib/p_test.nix { inherit pkgs; };
    };
}
