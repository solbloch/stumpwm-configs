(in-package :stumpwm)

(defun echo-key-seq (key key-seq cmd)
  (declare (ignore key cmd))
  (message "~a" (print-key-seq (reverse key-seq))))

(defcommand echo-key-seq-mode () ()
  "Toggle which-key-mode"
  (if (find 'echo-key-seq *key-press-hook*)
      (remove-hook *key-press-hook* 'echo-key-seq)
      (add-hook *key-press-hook* 'echo-key-seq)))
