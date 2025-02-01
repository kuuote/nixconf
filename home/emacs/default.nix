{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  tangle = inputs.org-babel.lib.tangleOrgBabel { languages = [ "emacs-lisp" ]; };
  init = builtins.readFile ./init.org;
  # init.orgから行頭に書かれた `nix: epkgs.ddskk` のような定義を抽出する
  decls = lib.pipe init [
    (builtins.split "\nnix: ([a-zA-z.\-]+)")
    (builtins.filter builtins.isList)
    (map (lib.flip builtins.elemAt 0))
  ];
  # AttrSetと `epkgs.ddskk` のような式を渡すと再帰的に参照する
  ref =
    set:
    lib.flip lib.pipe [
      (builtins.split "\\.")
      (builtins.filter builtins.isString)
      (builtins.foldl' (set: attr: set."${attr}") set)
    ];
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs.pkgs.withPackages (
      epkgs:
      let
        set = {
          inherit epkgs;
          orepkgs = import ./package { inherit pkgs; };
        };
      in
      builtins.map (ref set) decls
    );
  };
  home = {
    file = {
      ".emacs.d/init.el".text = tangle init;
      ".skk.el".text = ''
        (setq skk-large-jisyo "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L")
      '';
    };
  };
}
