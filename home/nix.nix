{
  pkgs,
  lib,
  inputs,
  ...
}@args:
let
  # configに影響する物を操作する際config自体にアクセスするとinfinite recursionになるので注意
  isStandalone = !(args ? "nixosConfig");
  mkFlakeRef = name: path: {
    nixPath = [
      "${name}=flake:${name}"
    ];
    registry = {
      "${name}" = {
        from = {
          type = "indirect";
          id = name;
        };
        to = {
          type = "path";
          inherit path;
        };
      };
    };
  };
  inherit (import ../lib/merge-attrs.nix) mergeAttrs;
in
{
  nix = mergeAttrs [
    # in NixOS, defined at https://github.com/nix-community/home-manager/blob/662fa98bf488daa82ce8dc2bc443872952065ab9/nixos/common.nix#L47
    # Nixの設定を書く際にはパッケージ指定を要求される
    (lib.optionalAttrs isStandalone {
      package = pkgs.nix;
    })
    {
      settings = import ../common/nixconf.nix;
    }
    (lib.optionalAttrs isStandalone (mkFlakeRef "nixpkgs" inputs.nixpkgs.outPath))
  ];
}
