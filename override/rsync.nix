{
  pkgs ? import <nixpkgs> { },
}:
pkgs.rsync.overrideAttrs {
  postPatch = ''
    # progressの出力間隔を50msにする
    cat progress.c | ${pkgs.perl}/bin/perl -pe 's/(msdiff.*?)\d\d\d\d/''${1}50/;' > progress.c_
    # diff -u progress.c progress.c_
    # exit 42
    cp progress.c_ progress.c
  '';
}
