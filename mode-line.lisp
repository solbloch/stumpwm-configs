(in-package :stumpwm)

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

(defun time? ()
  (let ((*days* '("monday" "tuesday" "wednesday" "thursday" "friday" "saturday" "sunday"))
        (*months* '("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec")))
    (multiple-value-bind
          (second minute hour date month year day-of-week dst-p tz)
        (get-decoded-time)
      (format nil "~2,'0d:~2,'0d:~2,'0d; ~a ~d ~2,'0d, ~d"
              hour
              minute
              second
              (nth day-of-week *days*)
              (nth (- month 1) *months*)
              date
              year
              (- tz)))))

(setf stumpwm:*screen-mode-line-format*
      (list  "%g | %w ^> | "
          '(:eval (time?))
          " | "
          '(:eval (network-state))))
