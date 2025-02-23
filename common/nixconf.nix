{
  # flakeが無いと始まらない感ある
  experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];
  # GC時にビルドデータを消さない
  keep-derivations = true;
  keep-outputs = true;
}
