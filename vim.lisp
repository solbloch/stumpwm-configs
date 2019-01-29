(in-package :stumpwm)
;; ;;-------~---~----------~----------~----
;; ;; Evil Mode for Stump using Windows Key ;;
;; ;;-------~---~----------~----------~----

;; Movement Mapping ;;
(stumpwm:define-key *top-map* (stumpwm:kbd "s-j") "move-focus down")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-h") "move-focus left")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-k") "move-focus up")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-l") "move-focus right")

(stumpwm:define-key *top-map* (stumpwm:kbd "s-J") "move-window down")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-H") "move-window left")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-K") "move-window up")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-L") "move-window right")

(stumpwm:define-key *top-map* (stumpwm:kbd "s-M") "exchange-direction down")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-N") "exchange-direction left")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-<") "exchange-direction up")
(stumpwm:define-key *top-map* (stumpwm:kbd "s->") "exchange-direction right")

(stumpwm:define-key *root-map* (stumpwm:kbd "J") "move-window down")
(stumpwm:define-key *root-map* (stumpwm:kbd "H") "move-window left")
(stumpwm:define-key *root-map* (stumpwm:kbd "K") "move-window up")
(stumpwm:define-key *root-map* (stumpwm:kbd "L") "move-window right")

;; Splits Windows and Frames
(stumpwm:define-key *top-map* (stumpwm:kbd "s-v") "hsplit")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-s") "vsplit")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-r") "remove")
(stumpwm:define-key *root-map* (stumpwm:kbd "q") "kill")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-q") "delete")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-Q") "killandremove")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-n") "pull-hidden-next")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-p") "pull-hidden-previous")
(stumpwm:define-key *top-map* (stumpwm:kbd "M-TAB") "fnext")
(stumpwm:define-key *top-map* (stumpwm:kbd "M-`") "pull-hidden-next")

;; Mouse Commands ;;
(stumpwm:define-key *top-map* (stumpwm:kbd "s-b")"banish")

;; Group Configuration ;;
;; (define-key *top-map* (kbd "s-N") "gnext")
(stumpwm:define-key *root-map* (stumpwm:kbd "N") "gnext")
;; (define-key *top-map* (kbd "s-m") "fullscreen")

;; Eval Commands ;;
(stumpwm:define-key *top-map* (stumpwm:kbd "s-;") "colon")
(stumpwm:define-key *top-map* (stumpwm:kbd "s-:") "eval")
(stumpwm:define-key *top-map* (stumpwm:kbd "M-:") "sudo-shell")

;; Commands :)
(defcommand killandremove () ()
  (stumpwm:run-commands
   "delete-window"
   "remove-split"))
