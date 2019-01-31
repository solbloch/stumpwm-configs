(in-package :stumpwm)

(set-font (make-instance 'xft:font :family "TerminessTTF Nerd Font" :subfamily "Bold" :size 18))

;; (mapc (lambda (x) (format t "Family: ~a  Subfamilies: ~{~a, ~}~%" x (clx-truetype:get-font-subfamilies x)) ) (clx-truetype:get-font-families))

;; mode-line config !
(setf *mode-line-timeout* 1
      *window-format* "%s%15t"
      *resize-increment* 35)

          ;; " | "
          ;; '(:eval (stumpwm:run-shell-command "amixer sget Master | grep 'Mono:' | awk -F'[][]' '{ print $2 }'" t))))

;; border size // width
(setf *maxsize-border-width* 5
      *normal-border-width* 5
      *window-border-style* :thick
      *message-window-gravity* :center
      *input-window-gravity* :center)

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

(defmacro deftheme (name (&key focus unfocus picture))
  `(defcommand ,name () ()
     (stumpwm:set-focus-color ,focus)
     (stumpwm:set-unfocus-color ,unfocus)
     (stumpwm:run-shell-command (concatenate 'string "feh --bg-scale '" ,picture "'"))))

(deftheme yoshis
    (:focus "#CF3C56"
     :unfocus "#521420"
     :picture "/home/sol/GOOGLE/backgrounds/stages/yoshis story.jpg"))

(deftheme bf
    (:focus "#52486A"
     :unfocus "#16041C"
     :picture "/home/sol/GOOGLE/backgrounds/stages/battlefield.png"))

(deftheme fod
    (:focus "#486398"
     :unfocus "#101f30"
     :picture "/home/sol/GOOGLE/backgrounds/stages/fountain of dreams.png"))

(deftheme dl
    (:focus "#137724"
     :unfocus "#072f0e"
     :picture "/home/sol/GOOGLE/backgrounds/stages/dreamland.png"))

(deftheme fd
    (:focus "#5A0C90"
     :unfocus "#1E0331"
     :picture "/home/sol/GOOGLE/backgrounds/stages/final destination.png"))

(deftheme jupiter
    (:focus "#5A0C90"
     :unfocus "#1E0331"
     :picture "/home/sol/GOOGLE/backgrounds/space/jupiter.png"))

(defun random-command (commands)
  (run-commands (nth (random (length commands)) commands)))

(random-command '("yoshis" "fod" "fd" "dl" "bf"))
