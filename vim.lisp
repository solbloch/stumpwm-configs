(in-package :stumpwm)
;; ;;-------~---~----------~----------~----
;; ;; Evil Mode for Stump using Windows Key ;;
;; ;;-------~---~----------~----------~----

;; Movement Mapping ;;
(define-key *top-map* (stumpwm:kbd "s-j") "move-focus down")
(define-key *top-map* (stumpwm:kbd "s-h") "move-focus left")
(define-key *top-map* (stumpwm:kbd "s-k") "move-focus up")
(define-key *top-map* (stumpwm:kbd "s-l") "move-focus right")

(define-key *top-map* (stumpwm:kbd "s-J") "move-window down")
(define-key *top-map* (stumpwm:kbd "s-H") "move-window left")
(define-key *top-map* (stumpwm:kbd "s-K") "move-window up")
(define-key *top-map* (stumpwm:kbd "s-L") "move-window right")

(define-key *top-map* (stumpwm:kbd "s-M") "exchange-direction down")
(define-key *top-map* (stumpwm:kbd "s-N") "exchange-direction left")
(define-key *top-map* (stumpwm:kbd "s-<") "exchange-direction up")
(define-key *top-map* (stumpwm:kbd "s->") "exchange-direction right")

(define-key *root-map* (stumpwm:kbd "J") "move-window down")
(define-key *root-map* (stumpwm:kbd "H") "move-window left")
(define-key *root-map* (stumpwm:kbd "K") "move-window up")
(define-key *root-map* (stumpwm:kbd "L") "move-window right")

;; Splits Windows and Frames
(stumpwm:define-key *root-map* (stumpwm:kbd "q") "kill")

;; Group Configuration ;;
;; (define-key *top-map* (kbd "s-N") "gnext")
(stumpwm:define-key *root-map* (stumpwm:kbd "N") "gnext")
;; (define-key *top-map* (kbd "s-m") "fullscreen")

;; Eval Commands ;;
(stumpwm:define-key *top-map* (stumpwm:kbd "s-;") "colon")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-:") "eval")
(stumpwm:define-key *top-map* (stumpwm:kbd "M-:") "sudo-shell")

