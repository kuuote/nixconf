{
  pkgs,
  src,
}:
pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
  allowSubstitutes = false;
  version = "latest";
  src = src;
  buildInputs = oldAttrs.buildInputs ++ [ pkgs.utf8proc ];
  # installPhaseでもビルド走るのでbuildPhaseを潰す
  buildPhase = "true";
  postInstall = ''
    ${oldAttrs.postInstall or ""}
    export > /build/export.txt
    find /build -type f | xargs cat | grep -Po '/nix/store/.{32}' | sort -u > $out/pathes-neovim
  '';
  nativeInstallCheckInputs = [ ];
  # 全依存をexportで吐き出してるから出力チェック潰さないと死ぬ
  # ref: https://discourse.nixos.org/t/getting-is-not-allowed-to-refer-to-the-following-paths-since-upgrading-to-unstable/21743
  disallowedRequisites = [ ];
})
