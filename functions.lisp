(in-package :stumpwm)

(defcommand yoshis () ()
  (stumpwm:set-focus-color "#CF3C56")
  (stumpwm:set-unfocus-color "#521420")
  (stumpwm:run-shell-command "feh --bg-scale '/home/sol/GOOGLE/backgrounds/stages/yoshis story.jpg'"))

(defcommand bf () ()
  (stumpwm:set-focus-color "#52486A")
  (stumpwm:set-unfocus-color "#16041C")
  (stumpwm:run-shell-command "feh --bg-scale /home/sol/GOOGLE/backgrounds/stages/battlefield.png"))

(defcommand fod () ()
  (stumpwm:set-focus-color "#486398")
  (stumpwm:set-unfocus-color "#101f30")
  (stumpwm:run-shell-command "feh --bg-scale '/home/sol/GOOGLE/backgrounds/stages/fountain of dreams.png'"))

(defcommand dl () ()
  (stumpwm:set-focus-color "#137724")
  (stumpwm:set-unfocus-color "#512B01")
  (stumpwm:run-shell-command "feh --bg-scale /home/sol/GOOGLE/backgrounds/stages/dreamland.png"))

(defcommand fd () ()
  (stumpwm:set-focus-color "#5A0C90")
  (stumpwm:set-unfocus-color "#1E0331")
  (stumpwm:run-shell-command "feh --bg-scale '/home/sol/GOOGLE/backgrounds/stages/final destination.png'"))

(defcommand jupiter () ()
  (stumpwm:set-focus-color "#5A0C90")
  (stumpwm:set-unfocus-color "#1E0331")
  (stumpwm:run-shell-command "feh --bg-tile '/home/sol/GOOGLE/backgrounds/space/jupiter.png'")
  )

(defcommand redshift () ()
  (stumpwm:run-shell-command "redshift -l 43.048122:-76.147423"))

(defcommand redshift-temp (temp) ((:number "temp?? :"))
  (stumpwm:run-shell-command (concatenate 'string "redshift -O " (write-to-string temp))))

(defun random-command (commands)
  (run-commands (nth (random (length commands)) commands)))

(random-command '("yoshis" "fod" "fd" "dl" "bf"))

(defun network-state ()
  (let* ((file (open "/sys/class/net/eno1/carrier"))
         (status (read-line file)))
    (if (string= status "1")
        "^2UP^n"
        "^1DOWN^n")))

(defun vpn-state ()
  (let ((vpn-string (run-shell-command "ps aux | grep '[o]penvpn'" t)))
    (if (= (length vpn-string) 0)
        "off"
        "on")))

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
