(defmacro pipe (name &rest exprs)
  (declare (indent 1))
  "anaphoric threading macro"
  `(let* ,(mapcar (lambda (e) `(,name ,e)) exprs) ,name))
(cond
 ((null (getenv "babel"))
  (add-to-list 'load-path "@site_lisp@")
  (add-to-list 'native-comp-eln-load-path "@native_lisp@")
  (require 'init))
 (t
  (let* ((my/tanglefile (file-truename "~/.emacs.d/init.org"))
         (curhash (with-temp-buffer
                    (insert-file-contents my/tanglefile)
                    (secure-hash 'sha256 (buffer-string))))
         (oldhash (condition-case nil
                      (with-temp-buffer
                        (insert-file-contents "/tmp/init.el.sum")
                        (buffer-string))
                    (error ""))))
    (unless (string= curhash oldhash)
      (find-file-read-only my/tanglefile)
      (pipe it
        (org-babel-tangle-collect-blocks)
        (mapcan 'cdr it) ;; per files => per blocks
        (seq-filter (lambda (a) (string= (car a) "emacs-lisp")) it)
        (mapcar (lambda (a) (elt a 6)) it)
        (string-join it "\n")
        (write-region it nil "/tmp/init.el")
        (kill-buffer))
      (write-region curhash nil "/tmp/init.el.sum")))
  (load "/tmp/init.el")))
