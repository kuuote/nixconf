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
        inherit inputs pkgs;
      };
      formatter.${system} = pkgs.nixfmt-rfc-style;
      homeConfigurations =
        let
          config =
            user:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = specialArgs;
              modules = [
                (import ./home user)
              ];
            };
        in
        {
          alice = config "alice"; # home-manager build用
          arch = config "arch";
        };
      nixosConfigurations = {
        latitude = nixpkgs.lib.nixosSystem {
          system = system;
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.nix-index-database.nixosModules.nix-index
            ./latitude
            ./latitude/home.nix
            {
              # 何かあった時のために現在のビルドソースへのリンクを作っておく
              environment.etc.nixconf.source = ./.;
              # inputsへのrefもあると便利そう
              environment.etc.inputs.source = inputs-pkg;
            }
          ];
        };
      };
      # for debug
      # packages.${system}.default = pkgs.callPackage ./pkgs/mycmds { };
      packages.${system} =
        let
          home-manager =
            let
              path = "${inputs.home-manager}";
              pkg = "${path}/home-manager";
            in
            pkgs.callPackage pkg { inherit path; };
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            name = "test";
            srcs = import ./shellpkgs.nix {
              inherit
                home-manager
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
                ln -s $src $out/
              done
              # 依存関係をGC対象から外すおまじない
              export > $out/export.txt
              # こちらでもinputsの参照をできるようにしておく
              ln -s ${inputs-pkg} $out/inputs
            '';
          };
          home-manager = home-manager;
          z = pkgs.stdenvNoCC.mkDerivation {
            name = "test";
            phases = [ "linkPhase" ];
            linkPhase = ''
              pwd
            '';
          };
        };
      templates = rec {
        default = develop;
        develop = {
          description = "devShellテンプレ";
          path = ./flake-template/develop;
        };
      };
    };
}
