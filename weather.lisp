(in-package :stumpwm)


;; (defun get-weather-request ()
;;   (jsown:parse
;;    (catch-host-not-found
;;      (dex:get (str:concat "https://api.darksky.net/forecast/"
;;                           darksky-id
;;                           "/43.034706,-76.12619?exclude=[hourly,daily,alerts,flags]")))))

(defvar *weather-info* '())

(defun get-weather-request ()
  (let ((request (handler-case
                     (flexi-streams:octets-to-string
                      (drakma:http-request (str:concat
                                            "https://api.openweathermap.org/data/2.5/"
                                            "weather?zip=11237&appid="
                                            openweather-id
                                            "&units=imperial")))
                   (usocket:ns-try-again-condition ()
                     nil))))
    (when request
      (jsown:parse request))))

(defcommand refresh-weather () ()
  (bt:make-thread
   (lambda ()
     (setf *weather-info* (get-weather-request)))))
