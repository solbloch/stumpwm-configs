(in-package :stumpwm)

(defun last1 (lst)
  (car (last lst)))

(defun network-ips ()
  (remove-if #'(lambda (x) (search "lo" x))
   (str:lines
    (async-run "ip a show | awk '/inet /{gsub(/[\/][0-9]+/,\"\"); print $NF \": \" $2}'"))))

(defun network-ip-string ()
  (let ((ip-list (network-ips)))
    (if ip-list
        (format nil "~{~a~^ ~}"ip-list)
        "DISCONNECTED")))

(defun network-interface ()
  (let ((proc-lines (slurp #P"/proc/net/route")))
    (when (> (length proc-lines) 1)
      (car (cl-ppcre:split "\\s" (cadr proc-lines))))))

(defun network-string ()
  (let* ((network-interface (network-interface))
         (up-down-binary (when network-interface
                           (slurp (str:concat "/sys/class/net/"
                                              network-interface
                                              "/carrier")))))
    (if (equalp "1" (car up-down-binary))
        (format nil "~a: ^2UP^7" network-interface)
        "^1DOWN^7")))

(defun memory-string ()
  (let* ((meminfo (slurp #P"/proc/meminfo"))
         (memtotal (/ (parse-integer
                       (cadr (cl-ppcre:split "\\s+" (car meminfo))))
                      1048576.0))
         (memavail (/ (parse-integer
                      (cadr (cl-ppcre:split "\\s+" (caddr meminfo))))
                     1048576.0) ))
    (format nil "~,1fG/~,1fG" (- memtotal memavail) memtotal)))

(defun vpn-state ()
  (let ((vpn-list (list-open-vpns)))
    (if vpn-list
        (format nil "vpn~p:~{~a~^,~}"
                (length vpn-list)
                (mapcar #'(lambda (vpn)
                            (cl-ppcre:regex-replace-all
                             ".*/(.*)\.ovpn.*" (car vpn) "\\1"))
                        vpn-list))
        "no vpn")))

;; ("월요일" "화요일" "수요일" "목요일" "금요일" "토요일" "일요일")
(defun time? ()
  (let ((days '("Mon" "Tues" "Wed" "Thurs" "Fri" "Sat" "Sun")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (declare (ignore second year))
      (format nil "~2,'0d:~2,'0d | ~a ~d/~d"
              hour
              minute
              ;; second
              (nth day-of-week days)
              month
              date))))

(defun cpu-temp ()
  (with-open-file (file "/sys/class/hwmon/hwmon1/temp1_input")
    (format nil "~,1f°" (float (/ (read file) 1000)))))

(defun weather-string ()
  (let ((weather-request *weather-info*))
    (if weather-request
        (format nil "~1$° ~a"
                (multi-val weather-request "main" "temp")
                (multi-val (car (multi-val weather-request "weather")) "description"))
        "weather unavailable")))

(defvar *mode-line-processing* nil)

(defun mode-line-processed ()
  *mode-line-processing*)

(defun update-mode-line-process ()
  (setf *mode-line-processing*
        (format nil "%g^>| ~{~A~^ | ~}"
                (list
                   ;; (weather-string)
                   (vpn-state)
                   (network-string)
                   (battery-string)
                   (get-volume-string)
                   ;; (cpu-temp)
                   (time?)))))

;; (setf stumpwm:*screen-mode-line-format*
;;       (list '(:eval (mode-line-processed))))

(setf stumpwm:*screen-mode-line-format*
      (list "%g^>| "
            '(:eval (battery-string))
            " | "
            '(:eval (network-ip-string))
            " | "
            '(:eval (memory-string))
            " | "
            '(:eval (weather-string))
            " | "
            '(:eval (cpu-temp))
            " | "
            '(:eval (time?))))
