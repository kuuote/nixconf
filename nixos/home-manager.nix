{
  user,
  inputs,
  ...
}@args:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = "${inputs.self.outPath}/home";
}
