{
  pkgs,
  ...
}:
let
  nixpkgs = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "3e3afe5174c561dee0df6f2c2b2236990146329f";
    hash = "sha256-frdhQvPbmDYaScPFiCnfdh3B/Vh81Uuoo0w5TkWmmjU=";
  };
  pkgs' = import nixpkgs { system = pkgs.system; };
in
{
  home.packages = [ pkgs'.deno ];
  home.sessionVariables.DENO_NO_UPDATE_CHECK = "true";
}
