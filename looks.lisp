(in-package :stumpwm)

(set-font (make-instance 'xft:font :family "TerminessTTF Nerd Font" :subfamily "Bold" :size 18))

;; (mapc (lambda (x) (format t "Family: ~a  Subfamilies: ~{~a, ~}~%" x (clx-truetype:get-font-subfamilies x)) ) (clx-truetype:get-font-families))

;; mode-line config !
(setf *mode-line-timeout* 1
      *window-format* "%s%15t"
      *resize-increment* 35)

(setf stumpwm:*screen-mode-line-format*
      (list  "%g | %w ^> | %d | "
          '(:eval (network-state))))
          ;; " | "
          ;; '(:eval (stumpwm:run-shell-command "amixer sget Master | grep 'Mono:' | awk -F'[][]' '{ print $2 }'" t))))

;; border size // width
(setf stumpwm:*maxsize-border-width* 5
      stumpwm:*normal-border-width* 5
      stumpwm:*window-border-style* :thick
      *message-window-gravity* :center)

;; gaps!
(setf swm-gaps:*inner-gaps-size* 13
      swm-gaps:*outer-gaps-size* 0)

(if (not swm-gaps:*gaps-on*)
    (swm-gaps:toggle-gaps))


(defvar *stages*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "y") "yoshis")
    (stumpwm:define-key m (stumpwm:kbd "b") "bf")
    (stumpwm:define-key m (stumpwm:kbd "F") "fod")
    (stumpwm:define-key m (stumpwm:kbd "f") "fd")
    (stumpwm:define-key m (stumpwm:kbd "d") "dl")
    m))

;; wallpapers :)
(defvar *looks-feels*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "g") "toggle-gaps")
    (stumpwm:define-key m (stumpwm:kbd "s") '*stages*)
    (stumpwm:define-key m (stumpwm:kbd "S") '*space*)
    m))

(defvar *space*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "j") "jupiter")
    m))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-A") '*looks-feels*)

(defvar *helpful-things*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "g") "toggle-gaps")
    (stumpwm:define-key m (stumpwm:kbd "s") "second-screen")
    (stumpwm:define-key m (stumpwm:kbd "r") '*redshift-levels*)
    m))

(defvar *redshift-levels*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "1") "redshift-temp 5500")
    (stumpwm:define-key m (stumpwm:kbd "2") "redshift-temp 4500")
    (stumpwm:define-key m (stumpwm:kbd "3") "redshift-temp 3500")
    (stumpwm:define-key m (stumpwm:kbd "4") "redshift-temp 2500")
    (stumpwm:define-key m (stumpwm:kbd "0") "exec redshift -x")
    m))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-w") '*helpful-things*)


;;; a bunch of commands that are themes :)

(defmacro deftheme (name (focus unfocus picture))
  `(defcommand ,name () ()
     (stumpwm:set-focus-color ,focus)
     (stumpwm:set-unfocus-color ,unfocus)
     (stumpwm:run-shell-command (concatenate 'string "feh --bg-scale '" ,picture "'"))))

(deftheme yoshis
    ("#CF3C56"
     "#521420"
     "/home/sol/GOOGLE/backgrounds/stages/yoshis story.jpg"))

(deftheme bf
    ("#52486A"
     "#16041C"
     "/home/sol/GOOGLE/backgrounds/stages/battlefield.png"))

(deftheme fod
    ("#486398"
     "#101f30"
     "/home/sol/GOOGLE/backgrounds/stages/fountain of dreams.png"))

(deftheme dl
    ("#137724"
     "#512B01"
     "/home/sol/GOOGLE/backgrounds/stages/dreamland.png"))

(deftheme fd
    ("#5A0C90"
     "#1E0331"
     "/home/sol/GOOGLE/backgrounds/stages/final destination.png"))

(deftheme jupiter
    ("#5A0C90"
     "#1E0331"
     "/home/sol/GOOGLE/backgrounds/space/jupiter.png"))

(defun random-command (commands)
  (run-commands (nth (random (length commands)) commands)))

(random-command '("yoshis" "fod" "fd" "dl" "bf"))
