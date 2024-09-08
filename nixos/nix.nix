{
  # flakeが無いと始まらない感ある
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
