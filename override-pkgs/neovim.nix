{
  pkgs,
  src,
}:
let
  # Neovimの先っちょが要求するのでとりあえず
  utf8proc-latest = pkgs.utf8proc.overrideAttrs {
    allowSubstitutes = false;
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "JuliaStrings";
      repo = "utf8proc";
      rev = "3de4596fbe28956855df2ecb3c11c0bbc3535838";
      sha256 = "sha256-DNnrKLwks3hP83K56Yjh9P3cVbivzssblKIx4M/RKqw=";
    };
    postInstall = ''
      export > /build/export.txt
      find /build -type f | xargs cat | grep -Po '/nix/store/.{32}' | sort -u > $out/pathes-utf8proc
    '';
  };
in
pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
  allowSubstitutes = false;
  version = "latest";
  src = src;
  buildInputs = oldAttrs.buildInputs ++ [ utf8proc-latest ];
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
