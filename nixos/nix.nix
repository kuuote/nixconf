{
  user,
  ...
}:
{
  nix.settings = (import ../common/nixconf.nix) // {
    trusted-users = [
      user
    ];
  };
}
