{
  nix.settings = (import ../common/nixconf.nix) // {
    trusted-users = [
      "alice"
    ];
  };
}
