{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    cargo
    crate2nix
    rust-analyzer
    rust.packages.stable.rustc-unwrapped
    rustfmt
  ];
}
