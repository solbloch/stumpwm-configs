(in-package :stumpwm)
(use-package :cl-inotify)

(defvar *config-list* (list #P"/home/sol/.spacemacs.d/init.el"
                            #P"/home/sol/.vimrc"
                            #P"/home/sol/.config/dunst/dunstrc"
                            #P"/home/sol/.zshrc"
                            #P"/home/sol/.tmux.conf"
                            #P"/home/sol/.xinitrc"
                            #P"/home/sol/.config/picom.conf"))

;; (when *initializing*
;;   (defvar *config-sync*
;;     (let ((command (format nil "/home/sol/.stumpwm.d/scripts/inotify-sync ~{~a~^ ~}" *config-list*)))
;;       (uiop:launch-program command))))

;; (defvar *remote-location* (str:concat "sol@solb.io:/home/sol/configs/" (machine-instance) "/"))

;; (defun rsync-file (path)
;;   (run-shell-command (str:concat "rsync -a " (namestring path) " " *remote-location*)))

;; (defun contiously-sync-file (path)
;;   (with-inotify (inot t (path :modify))
;;     (do-events (event inot :blocking-p t)
;;       (rsync-file path)
;;       (message "~a rsync'd." (file-namestring path)))))
