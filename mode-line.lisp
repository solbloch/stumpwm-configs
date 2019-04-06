(in-package :stumpwm)

(load-module "battery-portable")

(defun network-state ()
  (with-open-file (file *network-file*)
      (if (string= (read-line file) "1")
          "^2UP^n"
          "^1DOWN^n")))

(defun vpn-state-2 ()
  (if (probe-file "/var/log/ovpnserver.log")
      ;; fill in some stuff I guess ..
      "^2CONN^n"
      "^1DISC^n"))

(defun vpn-state ()
  (let ((vpn-string (async-run "ps aux | grep '[o]penvpn'")))
    (if (= (length vpn-string) 0)
        "off"
        "on")))

(defun time? ()
  (let ((days '("mon" "tues" "wed" "thurs" "fri" "sat" "sun"))
        (months '("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (format nil "~2,'0d:~2,'0d:~2,'0d; ~a ~d ~2,'0d, ~d"
              hour
              minute
              second
              (nth day-of-week days)
              (nth (- month 1) months)
              date
              year))))

(defun cpu-temp ()
  (with-open-file (file "/sys/class/hwmon/hwmon0/temp1_input")
    (format nil "~a" (float (/ (read file) 1000)))))

(setf stumpwm:*screen-mode-line-format*
      (list  "%g ^> | "
             "%B | "
             '(:eval (cpu-temp))
             "° | "
             '(:eval (time?))
             " | "
             '(:eval (network-state))))
