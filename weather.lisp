(in-package :stumpwm)

(defun get-weather-request ()
  (jsown:parse
   (catch-host-not-found
     (dex:get (str:concat "https://api.darksky.net/forecast/"
                          darksky-id
                          "/43.034706,-76.12619?exclude=[hourly,daily,alerts,flags]")))))
