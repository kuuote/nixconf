{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.emacs.enable = true;
  home.file = {
    ".emacs.d/init.el".text = ''
      (electric-pair-mode)
      (fido-vertical-mode)
      (set-language-environment "Japanese")
      (setq-default auto-save-default nil)
      (setq-default auto-save-list-file-prefix nil)
      (setq-default indent-tabs-mode nil)
      (setq-default inhibit-startup-screen t)
      (setq-default make-backup-files nil)
      (xterm-mouse-mode)

      (defun my/indent-buffer ()
        (interactive)
        (save-excursion
          (indent-region (point-min) (point-max))
          (untabify (point-min) (point-max))))
      (keymap-global-set "C-c i" #'my/indent-buffer)
    '';
  };
}
