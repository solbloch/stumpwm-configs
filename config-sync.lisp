(in-package :stumpwm)
(use-package :cl-inotify)

(defvar *config-list* (list "/home/sol/.spacemacs.d/init.el"
                            "/home/sol/.vimrc"
                            "/home/sol/.zshrc"
                            "/home/sol/.config/picom.conf"))

(defvar *remote-location* (str:concat "sol@solb.io:/home/sol/configs/" (machine-instance) "/"))

(defun rsync-file (path)
  (run-shell-command (str:concat "rsync -a " path " " *remote-location*)))

(defun contiously-sync-file (path)
  (with-inotify (inot t (path :close-write))
    (do-events (event inot :blocking-p t)
      (rsync-file path)
      (message "~a rsync'd." path))))

(if *initializing*
    (loop for path in *config-list*
          do (progn
               (rsync-file path)
               (bt:make-thread (lambda ()
                                 (contiously-sync-file path))))))
