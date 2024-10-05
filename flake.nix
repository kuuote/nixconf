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
      devShells.${system}.default = import ./shell.nix {
        inherit inputs pkgs;
      };
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
            {
              # 何かあった時のために現在のビルドソースへのリンクを作っておく
              environment.etc.nixconf.source = ./.;
              # inputsへのrefもあると便利そう
              environment.etc.inputs.source = pkgs.stdenvNoCC.mkDerivation {
                name = "links";
                phases = [ "linkPhase" ];
                linkPhase = ''
                  mkdir $out
                  ln -s ${inputs.nixpkgs} $out/nixpkgs
                  ln -s ${inputs.home-manager} $out/home-manager
                '';
              };
            }
          ];
        };
      };
      # for debug
      # packages.${system}.default = pkgs.callPackage ./pkgs/mycmds { };
      packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
        name = "test";
        srcs = import ./shellpkgs.nix {
          inherit inputs pkgs;
        };
        inputs = builtins.attrValues inputs;
        phases = [ "linkPhase" ];
        linkPhase = ''
          for src in $srcs; do
            mkdir -p $out/bin
            for bin in $src/bin/*; do
              ln -s $bin $out/bin/
            done
          done
          # 依存関係をGC対象から外すおまじない
          export > $out/export.txt

          ln -s ${inputs.nixpkgs} $out/nixpkgs
          ln -s ${inputs.home-manager} $out/home-manager
        '';
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
