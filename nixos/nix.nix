{
  nix.settings = {
    # flakeが無いと始まらない感ある
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "alice"
    ];
  };
}
