{
  pkgs,
  inputs,
  ...
}:
let
  tangle = inputs.org-babel.lib.tangleOrgBabel { languages = [ "emacs-lisp" ]; };
  init = builtins.readFile ./init.org;
  # init.orgから行頭に書かれた `nix: epkgs.ddskk` のような定義を抽出する
  decls =
    let
      a = builtins.split "\nnix: ([a-zA-Z.\-]+)" init;
      b = builtins.filter builtins.isList a;
      c = builtins.map (list: builtins.elemAt list 0) b;
    in
    c;
  # AttrSetと `epkgs.ddskk` のような式を渡すと再帰的に参照する
  ref =
    set: expr:
    let
      a = builtins.split "\\." expr;
      b = builtins.filter builtins.isString a;
      c = builtins.foldl' (set: attr: set."${attr}") set b;
    in
    c;
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
