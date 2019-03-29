(in-package :stumpwm)

(defcommand redshift () ()
  (stumpwm:run-shell-command "redshift -l 43.048122:-76.147423"))

(defcommand redshift-temp (temp) ((:number "temp?? : "))
  (stumpwm:run-shell-command (concatenate 'string "redshift -O " (write-to-string temp))))

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
  (all-windowlist "%s%100t"))

(defcommand emacs-fixed () ()
  (run-or-raise "env LC_CTYPE=ko_KR.UTF-8 emacs" '(:class "Emacs")))
