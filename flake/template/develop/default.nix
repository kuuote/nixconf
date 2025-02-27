{
  pkgs ? import <nixpkgs> { },
}:
pkgs.writeShellScript "test" "echo 42"
