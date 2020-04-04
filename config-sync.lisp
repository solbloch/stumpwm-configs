(in-package :stumpwm)
(use-package :cl-inotify)

(defvar *config-list* (list #P"/home/sol/.spacemacs.d/init.el"
                            #P"/home/sol/.vimrc"
                            #P"/home/sol/.zshrc"
                            #P"/home/sol/.tmux.conf"
                            #P"/home/sol/.config/picom.conf"))

(defvar *remote-location* (str:concat "sol@solb.io:/home/sol/configs/" (machine-instance) "/"))

(defun rsync-file (path)
  (run-shell-command (str:concat "rsync -a " (namestring path) " " *remote-location*)))

(defun contiously-sync-file (path)
  (with-inotify (inot t (path :close-write))
    (do-events (event inot :blocking-p t)
      (rsync-file path)
      (message "~a rsync'd." (file-namestring path)))))

(if *initializing*
    (loop for path in *config-list*
          do (progn
               (rsync-file path)
               (bt:make-thread
                (lambda ()
                  (contiously-sync-file path))
                :name (str:concat (file-namestring path) " sync")))))
