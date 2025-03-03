{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.self.packages.${pkgs.system}.nixshell
  ];
}
