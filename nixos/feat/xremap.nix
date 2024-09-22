{ pkgs }:
let
  xremap = pkgs.callPackage ../../pkgs/xremap { };
in
{
  environment.systemPackages = [ xremap ];
  hardware.uinput.enable = true;
}
