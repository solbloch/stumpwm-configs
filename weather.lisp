(in-package :stumpwm)

;; (defun get-weather-request ()
;;   (jsown:parse
;;    (catch-host-not-found
;;      (dex:get (str:concat "https://api.darksky.net/forecast/"
;;                           darksky-id
;;                           "/43.034706,-76.12619?exclude=[hourly,daily,alerts,flags]")))))

(defun get-weather-request ()
  (jsown:parse
   (catch-host-not-found
     (dex:get (str:concat "https://api.openweathermap.org/data/2.5/weather?lat=43.034706&lon=-76.12619&appid="
                          openweather-id
                          "&units=imperial")))))
