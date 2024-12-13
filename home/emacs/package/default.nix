{
  pkgs ? import <nixpkgs> { },
}:
{
  mr = import ./mr { inherit pkgs; };
}
