(in-package :stumpwm)

(defun battery-list ()
  (remove-if-not #'(lambda (supply)
                     (search "BAT" (namestring supply)))
                 (uiop:subdirectories "/sys/class/power_supply/")))

(defun battery-alist (battery)
  (with-open-file (stream (str:concat (namestring battery) "uevent"))
    (loop for line = (read-line stream nil)
          while line
          collect (let ((line-split (str:split #\= line)))
                    (cons (car line-split) (cadr line-split))))))

(defun cdr-assoc-string (item alist)
  (cdr (assoc item alist :test #'string=)))

(defun battery-string ()
  (when (battery-list)
    (let* ((bat-list (mapcar #'battery-alist (battery-list)))
           (perc-list '())
           (energy 0)
           (power 1)
           (capacity 0)
           (time-remaining 0)
           (status-list '()))
      (loop for bat in bat-list
            do (progn
                 (incf energy (parse-integer
                               (cdr-assoc-string "POWER_SUPPLY_ENERGY_NOW" bat)))
                 (incf power (parse-integer
                              (cdr-assoc-string "POWER_SUPPLY_POWER_NOW" bat)))
                 (incf capacity (parse-integer
                                 (cdr-assoc-string "POWER_SUPPLY_ENERGY_FULL" bat)))
                 (setf status-list (nconc status-list
                                          (list (cdr-assoc-string "POWER_SUPPLY_STATUS" bat))))
                 (setf perc-list (nconc perc-list
                                        (list `(,(cdr-assoc-string "POWER_SUPPLY_NAME" bat)
                                                ,(cdr-assoc-string "POWER_SUPPLY_CAPACITY" bat)))))))
      (setf time-remaining
            (if (= power 1)
                0
                (if (find "Charging" status-list :test #'string=)
                    (/ (- capacity energy) power)
                    (/ energy power))))
      (format nil "~a:~2,'0D - ~{~{~a~^:~}%~^ ~}"
              (floor time-remaining)
              (round (* 60 (rem time-remaining 1.0)))
              perc-list))))
