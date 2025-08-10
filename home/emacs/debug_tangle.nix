{
  pkgs ? import <nixpkgs> { },
}:
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
  ''
