{
  pkgs ? import <nixpkgs> { },
}:
pkgs.rustPlatform.buildRustPackage {
  name = "nixos-apply";
  src = ./rs;
  cargoLock = {
    lockFile = ./rs/Cargo.lock;
  };
}
