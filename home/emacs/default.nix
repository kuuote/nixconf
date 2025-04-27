{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  init = builtins.readFile ./init.org;
  # init.orgから行頭に書かれた `nix: epkgs.ddskk` のような定義を抽出する
  decls =
    init |> lib.split "\nnix: ([a-zA-z.\-]+)" |> lib.filter lib.isList |> map (lib.flip lib.elemAt 0);
  # AttrSetと `epkgs.ddskk` のような式を渡すと再帰的に参照する
  ref =
    set: decls:
    decls
    |> builtins.split "\\."
    |> builtins.filter builtins.isString
    |> builtins.foldl' (set: attr: set."${attr}") set;
  # declsをrefしてパッケージを集める
  packageRequires =
    let
      set = {
        epkgs = pkgs.emacsPackages;
        orepkgs = import ./package { inherit pkgs; };
      };
    in
    builtins.map (ref set) decls;
  init_src =
    pkgs.runCommandLocal "init_src"
      {
        nativeBuildInputs = [ pkgs.emacs ];
        batch = builtins.toFile "batch.el" ''
          (progn
            (require 'ob-tangle)
            (org-babel-tangle-file "init.org" "init.el" "emacs-lisp"))
        '';
      }
      ''
        cp ${./init.org} init.org
        emacs --batch --script $batch
        echo "(provide 'init)" >> init.el
        install -D init.el $out/init.el
      '';
  init_pkg = pkgs.emacsPackages.melpaBuild {
    pname = "init";
    version = "0";
    src = init_src;
    inherit packageRequires;
  };
in
{
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs.pkgs.withPackages packageRequires;
    };
    git = {
      # .dir-locals.elをコミットできるよう分かれてるらしいので
      # .dir-locals-2.elは常に除外しといていいらしい
      ignores = [
        ".dir-locals-2.el"
      ];
    };
  };
  home = {
    file = {
      ".emacs.d/init.el".source = pkgs.replaceVars ./init.el {
        site_lisp = "${init_pkg}/share/emacs/site-lisp/elpa/init-0";
        native_lisp = "${init_pkg}/share/emacs/native-lisp";
      };
      ".emacs.d/init_built.el".source = "${init_src}/init.el";
      ".emacs.d/init".source = init_pkg;
      ".skk.el".text = ''
        (setq skk-large-jisyo "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L")
      '';
    };
  };
}
