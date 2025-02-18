{
  pkgs ? import <nixpkgs> { },
}:
let
  lib = pkgs.lib;
  root = builtins.toString ./rs;
  src = builtins.path {
    path = root;
    filter =
      path: type:
      let
        relpath = lib.substring (lib.stringLength root) (lib.stringLength path) path;
      in
      lib.any (lib.flip lib.hasPrefix relpath) [
        "/Cargo.lock"
        "/Cargo.nix"
        "/Cargo.toml"
        "/src"
      ];
  };
in
(import "${src}/Cargo.nix" { inherit pkgs; }).rootCrate.build
