(in-package :stumpwm)

(defcommand killandremove () ()
  (stumpwm:run-commands
   "delete-window"
   "remove-split"))

(defcommand redshift-temp (temp) ((:number "temp?? : "))
  (run-shell-command (str:concat "redshift -O " (write-to-string temp))))

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
  (run-or-raise "emacsclient -c" '(:class "Emacs")))

(defcommand spotify () ()
  (run-or-raise "spotify" '(:class "Spotify")))

(defun percent (perc)
  (let ((on-string (make-string (floor (/ perc 5)) :initial-element #\▒)))
    (message "~a~a" on-string
             (make-string (- 20 (floor (/ perc 5))) :initial-element #\ ))))

;; (defcommand fix-audio () ()
;;   (run-shell-command "pacmd set-card-profile alsa_card.pci-0000_01_00.1 off"))

(defcommand sleep-pc () ()
  (run-shell-command "sleep 1; xset dpms force off"))

(defcommand fix-discord () ()
  (run-shell-command
   (str:concat "pacmd set-card-profile "
               "alsa_card.usb-046d_0825_C4BFA9D0-02 "
               "off"))
  (sleep .01)
  (run-shell-command
   (str:concat "pacmd set-card-profile "
               "alsa_card.usb-046d_0825_C4BFA9D0-02 "
               "input:multichannel-input"))
  (send-fake-key (current-window) (kbd "C-r")))

(defun mode-line-group-scroll (mode-line button x y)
  (declare (ignore mode-line x y))
  (case button
    (4 (gprev))
    (5 (gnext))
    (t nil)))

(defun )

(when *initializing*
  (add-hook *mode-line-click-hook* #'mode-line-group-scroll))
