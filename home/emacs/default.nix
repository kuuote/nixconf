{
  pkgs,
  inputs,
  ...
}:
let
  tangle = inputs.org-babel.lib.tangleOrgBabel { languages = [ "emacs-lisp" ]; };
  init = builtins.readFile ./init.org;
in
{
  programs.emacs.enable = true;
  home = {
    file = {
      ".emacs.d/init.el".text = tangle init;
    };
  };
}
