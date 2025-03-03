(cond
 ((null (getenv "babel"))
  (add-to-list 'load-path "@site_lisp@")
  (add-to-list 'native-comp-eln-load-path "@native_lisp@")
  (require 'init))
 (t
  (find-file-read-only (file-truename "~/.emacs.d/init.org"))
  (require 'dash)
  (-->
   (org-babel-tangle-collect-blocks)
   (mapcan 'cdr it) ;; per files => per blocks
   (seq-filter (lambda (a) (string= (car a) "emacs-lisp")) it)
   (mapcar (-cut elt <> 6) it)
   (string-join `("(progn" ,@it ")") "\n")
   (car (read-from-string it))
   (progn
     (kill-buffer)
     (eval it)))))
