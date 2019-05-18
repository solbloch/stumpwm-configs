(in-package :stumpwm)

(defun slurp (file)
  "slurp in a little file (one line file)"
  (with-open-file (temp-stream file)
    (read temp-stream)))

(defun slurp-stream (file)
  "slurp in a little file (one line file)"
  (with-open-file (temp-stream file)
    (read-line temp-stream)))

(defun battery-percent ()
  (let ((charge-full (slurp "/sys/class/power_supply/BAT0/charge_full"))
        (charge-now (slurp "/sys/class/power_supply/BAT0/charge_now")))
    (float (* 100 (/ charge-now charge-full)))))

(defun battery-remaining-discharging ()
  (let ((charge-now (slurp "/sys/class/power_supply/BAT0/charge_now"))
        (current-now (slurp "/sys/class/power_supply/BAT0/current_now")))
    (floor (float (/ charge-now current-now)))))

(defun battery-remaining-charging ()
  (let ((charge-now (slurp "/sys/class/power_supply/BAT0/charge_now"))
        (current-now (slurp "/sys/class/power_supply/BAT0/current_now")))
    (floor (float (/ charge-now current-now)))))

(defun battery-string ()
  (if (search "Disch" (slurp-stream "/sys/class/power_supply/BAT0/status"))
      (multiple-value-bind (hours minutes) (battery-remaining-discharging)
        (format nil "~a:~2,'0D-^7 ~a% ^n" hours (round (* 60 minutes)) (round (battery-percent))))
      "off "))
