;;; mr.el --- mrw -*- lexical-binding: t -*-

;; Most Recently Written like https://github.com/lambdalisue/vim-mr

;;; Code:
(defcustom mr-mrw-filename "/data/mr/mrw"
  "file for mrw"
  :group 'mr
  :type '(file))

(defvar mr-mrw-list '())

(defun mr-mrw-list ()
  (setq
   mr-mrw-list
   (with-temp-buffer
     (insert-file-contents mr-mrw-filename)
     ;; 何も設定してないのでno-propertiesじゃなくていい
     (split-string (buffer-string) "\n" t)))
  (setq recentf-list mr-mrw-list))

(defun mr-mrw-savefile ()
  (write-region (string-join mr-mrw-list "\n") nil mr-mrw-filename nil 'nomsg))

(defun mr-mrw-record ()
  (interactive)
  (mr-mrw-list)
  (let ((filename (file-truename buffer-file-name)))
    (setq mr-mrw-list (cons filename (delete filename mr-mrw-list))))
  (mr-mrw-savefile))

(defun consult-mrw ()
  (interactive)
  (require 'consult)
  (find-file
   (consult--read
    (mr-mrw-list)
    :category 'file
    :require-match t
    :state (consult--file-preview)
    :sort nil)))

;;;###autoload
(define-minor-mode mr-mode
  "record recent files"
  :global t
  (remove-hook 'after-save-hook #'mr-mrw-record)
  (when mr-mode
    (add-hook 'after-save-hook #'mr-mrw-record)))

(provide 'mr)
;;; mr.el ends here
