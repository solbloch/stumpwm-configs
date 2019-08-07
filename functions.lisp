(in-package :stumpwm)

(defcommand killandremove () ()
  (stumpwm:run-commands
   "delete-window"
   "remove-split"))

(defcommand redshift () ()
  (run-shell-command "redshift -l 43.048122:-76.147423"))

(defcommand redshift-temp (temp) ((:number "temp?? : "))
  (run-shell-command (concatenate 'string "redshift -O " (write-to-string temp))))

(defcommand all-windowlist (&optional (fmt *window-format*)
                            window-list) (:rest)
  (let ((window-list (or window-list
                         (sort-windows-by-number
                          (screen-windows (current-screen))))))
    (if (null window-list)
        (message "No Managed Windows")
        (let ((window (select-window-from-menu window-list fmt)))
          (if window
              (progn
                (switch-to-group (window-group window))
                (group-focus-window (window-group window) window))
              (throw 'error :abort))))))

(defcommand all-windowlist-formatted () ()
  (all-windowlist "%s%300t"))

(defcommand ripcord () ()
  (run-or-raise "ripcord" '(:class "Ripcord")))

(defcommand darktable () ()
  (run-or-raise "darktable" '(:class "Darktable")))

(defcommand telegram () ()
  (run-or-raise "telegram-desktop" '(:class "Telegram")))


(defcommand emacs-fixed () ()
  (run-or-raise "env LC_CTYPE=ko_KR.UTF-8 emacs" '(:class "Emacs")))

(defcommand spotify () ()
  (run-or-raise "spotify" '(:class "Spotify")))

(defcommand slack () ()
  (run-or-raise "slack" '(:class "Slack")))

(defun percent (perc)
  (let ((on-string (make-string (floor (/ perc 5)) :initial-element #\▒)))
    (message (concatenate 'string on-string
                          (make-string (- 20 (floor (/ perc 5))) :initial-element #\ )))))
