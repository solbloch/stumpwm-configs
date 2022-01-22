(in-package :stumpwm)

(defvar *mta-info* '())

(defun refresh-mta ()
  (dex:get "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-jz"
           :headers `(("x-api-key" . ,mta-id))))

(defun get-weather-request ()
  (let ((request (handler-case
                     (flexi-streams:octets-to-string
                      (drakma:http-request (str:concat
                                            "https://api.openweathermap.org/data/2.5/"
                                            "weather?zip=11221&appid="
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
