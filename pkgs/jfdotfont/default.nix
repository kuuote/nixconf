{
  fetchurl,
  pkgs,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jfdotfont";
  version = "20150527";

  src = fetchurl {
    url = "https://ftp.iij.ad.jp/pub/osdn.jp/users/8/8541/jfdotfont-20150527.7z";
    hash = "sha256-P+NtqJaXSKQo6zC41vXLK+T3s1IYh2QRYJtisggVS7Y=";
  };

  nativeBuildInputs = with pkgs; [ p7zip ];

  phases = [ "installPhase" ];

  installPhase = ''
    7z e -y $src
    install -m444 -Dt $out/share/fonts/jfdotfont *.ttf
    export > $out/export.txt
  '';
}
