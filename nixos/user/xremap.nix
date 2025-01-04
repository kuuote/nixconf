{
  pkgs,
  user,
  ...
}:
let
  xremap = pkgs.callPackage ../../pkgs/xremap { };
in
{
  hardware.uinput.enable = true;
  users.users.${user} = {
    extraGroups = [
      "input" # for xremap
      "uinput" # for xremap
    ];
    packages = [ xremap ];
  };
}
