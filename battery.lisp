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
    (flet ((f (str obj) (parse-integer (cdr-assoc-string str obj))))
     (multiple-value-bind
           (energy power capacity status-list perc-list)
         (loop for bat in (mapcar #'battery-alist (battery-list))
               summing (f "POWER_SUPPLY_ENERGY_NOW" bat) into energy
               summing (f "POWER_SUPPLY_POWER_NOW" bat) into power
               summing (f "POWER_SUPPLY_ENERGY_FULL" bat) into capacity
               collecting (cdr-assoc-string "POWER_SUPPLY_STATUS" bat) into status-list
               collecting (mapcar #'(lambda (string) (cdr-assoc-string string bat))
                                  '("POWER_SUPPLY_NAME" "POWER_SUPPLY_CAPACITY"))
                 into perc-list
               finally (return (values energy power capacity status-list perc-list)))
       (let ((time-remaining
               (if (= power 0) 0
                   (if (find "Charging" status-list :test #'string=)
                       (/ (- capacity energy) power)
                       (/ energy power)))))
         (format nil "~a:~2,'0D - ~{~{~a~^:~}%~^ ~}"
                 (floor time-remaining)
                 (round (* 60 (rem time-remaining 1.0)))
                 perc-list))))))
