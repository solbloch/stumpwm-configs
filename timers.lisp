(in-package :stumpwm)

(when *initializing*
  (progn
    (defvar *clipboard-timer*
      (run-with-timer 1 1 (lambda () (remember-clipboard))))
    (defvar *weather-timer*
      (run-with-timer
       0 180
       #'(lambda () (refresh-weather))))))
  ;; (defvar *mode-line-processing-timer*
  ;;   (run-with-timer 1 4 (lambda () (ignore-errors
  ;;                                   (update-mode-line-process))))))

;; (defvar *ttf-font-timer*
;;   (run-with-timer
;;    900 900
;;    (lambda ()
;;      (loop for font in (stumpwm::screen-fonts (current-screen))
;;            when (typep font 'xft:font)
;;              do (clrhash (xft::font-string-line-bboxes font))
;;                 (clrhash (xft::font-string-line-alpha-maps font))
;;                 (clrhash (xft::font-string-bboxes font))
;;                 (clrhash (xft::font-string-alpha-maps font))))))
