{
  pkgs,
  src,
}:
pkgs.vim.overrideAttrs (oldAttrs: {
  version = "latest";
  src = src;
  buildInputs = oldAttrs.buildInputs ++ [ pkgs.lua ];
  configureFlags = oldAttrs.configureFlags ++ [
    "--enable-luainterp"
    "--with-lua-prefix=${pkgs.lua}"
    "--enable-fail-if-missing"
  ];
  postInstall = ''
    ${oldAttrs.postInstall}
    export > $out/export.txt
  '';
})
