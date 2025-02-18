{
  pkgs ? import <nixpkgs> { },
}:
pkgs.runCommandLocal "nixos-apply" { } ''
  install -Dm 0755 ${./nixos-apply.sh} $out/bin/nixos-apply
  sed -i -e "1c#!${pkgs.runtimeShell}" $out/bin/nixos-apply
''
