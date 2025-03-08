{
  user,
  inputs,
  specialArgs,
  ...
}@args:
{
  home-manager.extraSpecialArgs = specialArgs;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = {
    imports = specialArgs.homeManagerModules;
  };
  imports = [ inputs.home-manager.nixosModules.home-manager ];
}
