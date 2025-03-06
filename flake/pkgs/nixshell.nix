{
  perSystem = (
    {
      pkgs,
      ...
    }:
    {
      # 手軽にnixpkgsのパッケージを引っ張ってくるためのhelper
      packages.nixshell =
        let
          # 引数をREPLYに詰めて、flake指定が無かったらnixpkgs#を付けて返す
          cmp_nixpkgs = builtins.toFile "cmp_nixpkgs" ''
            cmp_nixpkgs() {
              REPLY=("$@")
              local i
              for i in ''${!REPLY[@]}; do
                if echo ''${REPLY[$i]} | grep -q -v '#'; then
                  REPLY[$i]="nixpkgs#''${REPLY[$i]}"
                fi
              done
            }
          '';
          option = "-L --inputs-from self --option flake-registry ''";
        in
        pkgs.linkFarm "nixshell" {
          "bin/ni" = pkgs.writeShellScript "ni" ''
            source ${cmp_nixpkgs}
            cmp_nixpkgs "$@"
            nix profile install ${option} "''${REPLY[@]}"
          '';
          "bin/ns" = pkgs.writeShellScript "ns" ''
            source ${cmp_nixpkgs}
            cmp_nixpkgs "$@"
            nix shell ${option} "''${REPLY[@]}"
          '';
        };
    }
  );
}
