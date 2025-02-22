{
  user,
  inputs,
  specialArgs,
  ...
}@args:
{
  home-manager.extraSpecialArgs = specialArgs // {
    isNixOSHost = true;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = "${inputs.self.outPath}/home";
  imports = [ inputs.home-manager.nixosModules.home-manager ];
}
