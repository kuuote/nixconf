{
  user,
  ...
}:
{
  hardware.acpilight.enable = true;
  users.users.${user}.extraGroups = [ "video" ];
}
