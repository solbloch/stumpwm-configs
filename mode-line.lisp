(in-package :stumpwm)

(load-module "battery-portable")

(defun network-state ()
  (with-open-file (file *network-file*)
    (if (string= (read-line file) "1")
        "^2연결됨^n"
        "^1연결안됨^n")))

(defun vpn-state ()
  (let ((vpn-string (async-run "ps aux | grep '[o]penvpn'")))
    (if (= (length vpn-string) 0)
        "off"
        "on")))

(defun time? ()
  (let ((days '("워요일" "화요일" "수요일" "목요일" "금요일" "토요일" "일요일"))
        (months '("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (format nil "~2,'0d:~2,'0d:~2,'0d; ~d월 ~d일 ~a   "
              hour
              minute
              second
              month
              date
              (nth day-of-week days)))))

(defun cpu-temp ()
  (with-open-file (file "/sys/class/hwmon/hwmon2/temp1_input")
    (format nil "~a" (float (/ (read file) 1000)))))
