(in-package :stumpwm)

(set-font (make-instance 'xft:font :family "TerminessTTF Nerd Font" :subfamily "Bold" :size 18))

;; (mapc (lambda (x) (format t "Family: ~a  Subfamilies: ~{~a, ~}~%" x (clx-truetype:get-font-subfamilies x)) ) (clx-truetype:get-font-families))

;; mode-line config !
(setf *mode-line-timeout* 1)
(setf *window-format* "%s%15t")
(setf *resize-increment* 35)

(setf stumpwm:*screen-mode-line-format*
      (list  "%g | %w ^> | %d | %c| "
          '(:eval (network-state))
          " | "
	'(:eval (stumpwm:run-shell-command "amixer sget Master | grep 'Mono:' | awk -F'[][]' '{ print $2 }'" t))))

;; border size // width
(setf stumpwm:*maxsize-border-width* 5)
(setf stumpwm:*normal-border-width* 5)
(setf stumpwm:*window-border-style* :thick)

(setf *message-window-gravity* :center)

;; gaps!
(setf swm-gaps:*inner-gaps-size* 13)
(setf swm-gaps:*outer-gaps-size* 0)
(if (not swm-gaps:*gaps-on*)
   (swm-gaps:toggle-gaps))


(defvar *stages*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "y") "yoshis")
    (stumpwm:define-key m (stumpwm:kbd "b") "bf")
    (stumpwm:define-key m (stumpwm:kbd "F") "fod")
    (stumpwm:define-key m (stumpwm:kbd "f") "fd")
    (stumpwm:define-key m (stumpwm:kbd "d") "dl")
    m ; NOTE: this is important
    ))

;; wallpapers :)
(defvar *looks-feels*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "g") "toggle-gaps")
    (stumpwm:define-key m (stumpwm:kbd "s") '*stages*)
    (stumpwm:define-key m (stumpwm:kbd "S") '*space*)
    m ; NOTE: this is important
    ))

(defvar *space*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "j") "jupiter")
    m ; NOTE: this is important
    ))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-A") '*looks-feels*)

(defvar *helpful-things*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "g") "toggle-gaps")
    (stumpwm:define-key m (stumpwm:kbd "s") "second-screen")
    (stumpwm:define-key m (stumpwm:kbd "r") '*redshift-levels*)
    m ; NOTE: this is important
    ))

(defvar *redshift-levels*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "1") "redshift-temp 5500")
    (stumpwm:define-key m (stumpwm:kbd "2") "redshift-temp 4500")
    (stumpwm:define-key m (stumpwm:kbd "3") "redshift-temp 3500")
    (stumpwm:define-key m (stumpwm:kbd "4") "redshift-temp 2500")
    (stumpwm:define-key m (stumpwm:kbd "0") "exec redshift -x")
    m ; NOTE: this is important
    ))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-w") '*helpful-things*)


;; (random-function (stumpwm:dl stumpwm:fd stumpwm:fod stumpwm:bf stumpwm:yoshis))
