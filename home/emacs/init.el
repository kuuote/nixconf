(cond
 ((null (getenv "babel"))
  (load "~/.emacs.d/init_built.el"))
 (t
  (find-file-read-only (file-truename "~/.emacs.d/init.org"))
  (require 'dash)
  (-->
   (org-babel-tangle-collect-blocks)
   (mapcan 'cdr it) ;; per files => per blocks
   (seq-filter (lambda (a) (string= (car a) "emacs-lisp")) it)
   (mapcar (-cut elt <> 6) it)
   (apply 'concat `("(progn" ,@it ")"))
   (car (read-from-string it))
   (progn
     (kill-buffer)
     (eval it)))))
