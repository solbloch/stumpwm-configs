(in-package :stumpwm)

(set-font "-xos4-terminus-bold-r-normal--20-200-72-72-c-100-iso10646-1")

;; azrin
(define-frame-preference "1"
  (0 t t :class "firefox"))

(define-frame-preference "2"
  (0 t nil :CLASS "Spotify" :INSTANCE "spotify")
  (1 t t :class "discord"))
