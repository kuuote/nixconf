{
  nix.settings = {
    # flakeが無いと始まらない感ある
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # GC時にビルドデータを消さない
    keep-outputs = true;
    trusted-users = [
      "alice"
    ];
  };
}
