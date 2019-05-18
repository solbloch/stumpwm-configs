(in-package :stumpwm)

;; mode-line config !
(setf *mode-line-timeout* 1
      *window-format* "%s%15t"
      *resize-increment* 35)

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
