(in-package :stumpwm)

;; (run-shell-command "picom")
;; (run-shell-command "redshift -l 43.0481:-76.1474 -t 6300:4000")

;; mode-line config !
(setf *mode-line-timeout* 1
      *window-format* "%s%15t"
      *group-format* "%t"
      *resize-increment* 35
      *mode-line-position* :top
      *mode-line-background-color* "#2b2b2b"
      *mode-line-foreground-color* "#E5E9F0")

;; border size // width
(setf *maxsize-border-width* 5
      *normal-border-width* 5
      *window-border-style* :thick
      *message-window-gravity* :center
      *input-window-gravity* :center)

;; gaps!
;; (setf swm-gaps:*inner-gaps-size* 13
      ;; swm-gaps:*outer-gaps-size* 0)

;; (if (not swm-gaps:*gaps-on*)
    ;; (swm-gaps:toggle-gaps))

(when *initializing*
  (mode-line))

;;; a bunch of commands that are themes :)
(defvar *background-location* "/home/sol/Pictures/backgrounds/")

(defmacro deftheme (name (&key focus unfocus picture))
  `(defcommand ,name () ()
     (stumpwm:set-focus-color ,focus)
     (stumpwm:set-unfocus-color ,unfocus)
     (stumpwm:run-shell-command (str:concat "feh --bg-scale '",*background-location* ,picture "'"))))

(deftheme yoshis
    (:focus "#CF3C56"
     :unfocus "#521420"
     :picture "stages/yoshis story.jpg"))

(deftheme bf
    (:focus "#52486A"
     :unfocus "#16041C"
     :picture "stages/battlefield.png"))

(deftheme fod
    (:focus "#486398"
     :unfocus "#101f30"
     :picture "stages/fountain of dreams.png"))

(deftheme dl
    (:focus "#137724"
     :unfocus "#072f0e"
     :picture "stages/dreamland.png"))

(deftheme fd
    (:focus "#5A0C90"
     :unfocus "#1E0331"
     :picture "stages/final destination.png"))

(deftheme jupiter
    (:focus "#5A0C90"
     :unfocus "#1E0331"
     :picture "space/jupiter.png"))

(defun random-command (commands)
  (run-commands (nth (random (length commands)) commands)))

(random-command '("yoshis" "fod" "fd" "dl" "bf"))
