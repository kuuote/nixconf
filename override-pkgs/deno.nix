{
  fetchFromGitHub,
  system,
}:
let
  nixpkgs = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "5df43628fdf08d642be8ba5b3625a6c70731c19c";
    hash = "sha256-Tbk1MZbtV2s5aG+iM99U8FqwxU/YNArMcWAv6clcsBc=";
  };
  pkgs = import nixpkgs {
    inherit system;
  };
in
pkgs.deno
