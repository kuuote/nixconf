{
  pkgs,
  ...
}:
{
  security.wrappers = {
    nixos-apply = {
      source = "${pkgs.callPackage ./. { }}/bin/nixos-apply";
      owner = "root";
      group = "root";
      setuid = true;
      permissions = "u+rx,g+x,o+x";
    };
  };
}
