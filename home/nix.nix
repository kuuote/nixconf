{
  pkgs,
  lib,
  ...
}@args:
let
  # configに影響する物を操作する際config自体にアクセスするとinfinite recursionになるので注意
  isStandalone = !(args ? "nixosConfig");
  mkFlakeRef = name: path: {
    nixPath = [
      "${name}=flake"
      name
    ];
    registry = {
      "${name}" = {
        from = {
          type = "indirect";
          id = name;
        };
        to = {
          type = "path";
          # Pathを直接変換かけると謎のコピーが走ることがあるのでtoStringかます
          path = if builtins.isPath path then builtins.toString path else "${path}";
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
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        keep-derivations = true;
        keep-outputs = true;
      };
    }
    (lib.optionalAttrs isStandalone (mkFlakeRef "nixpkgs" pkgs.path))
  ];
}
