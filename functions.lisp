(in-package :stumpwm)

(defcommand redshift () ()
  (stumpwm:run-shell-command "redshift -l 43.048122:-76.147423"))

(defcommand redshift-temp (temp) ((:number "temp?? :"))
  (stumpwm:run-shell-command (concatenate 'string "redshift -O " (write-to-string temp))))


(defun network-state ()
  (let* ((file (open "/sys/class/net/eno1/carrier"))
         (status (read-line file)))
    (if (string= status "1")
        "^2UP^n"
        "^1DOWN^n")))

(defun vpn-state-2 ()
  (if (probe-file "/var/log/ovpnserver.log")
      ;; fill in some stuff I guess ..
      "^2CONN^n"
      "^1DISC^n"))

(defun vpn-state ()
  (let ((vpn-string (run-shell-command "ps aux | grep '[o]penvpn'" t)))
    (if (= (length vpn-string) 0)
        "off"
        "on")))

(defcommand volume-up () ()
  (run-shell-command "pulseaudio-ctl up"))

(defcommand volume-down () ()
  (run-shell-command "pulseaudio-ctl down"))

(defcommand volume-mute () ()
  (run-shell-command "pulseaudio-ctl mute"))

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
  (all-windowlist "%s%60t"))
