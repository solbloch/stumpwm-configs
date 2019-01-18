(in-package :stumpwm)

(define-stumpwm-type :password (input prompt)
  (or (argument-pop input)
      (read-one-line (current-screen) prompt :password t)))

(defcommand passtest (sym) ((:password "type something: "))
  (message "~a" (with-output-to-string (s)
                  (describe sym s))))

