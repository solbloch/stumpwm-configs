(in-package :stumpwm)

;; Applications ;;
(defvar *application-bindings*
   (let ((m (stumpwm:make-sparse-keymap)))
     (stumpwm:define-key m (stumpwm:kbd "e") "emacs")
     (stumpwm:define-key m (stumpwm:kbd "u") "run-shell-command 'urxvt -e /usr/bin/fish'")
     (stumpwm:define-key m (stumpwm:kbd "XF86AudioPlay") "run-shell-command spotify")
     (stumpwm:define-key m (stumpwm:kbd "c") "run-shell-command google-chrome-stable")
     (stumpwm:define-key m (stumpwm:kbd "b") "run-shell-command evince")
     m))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "s-a") '*application-bindings*)
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-space") "run-shell-command rofi -show run -font 'TerminessTTF Nerd Font 24'")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "s-RET") "run-shell-command urxvt -e /usr/bin/fish")



;; Group Configuration ;;
(defvar *group-bindings*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "h") "gprev")
    (stumpwm:define-key m (stumpwm:kbd "l") "gnext")
    (stumpwm:define-key m (stumpwm:kbd "L") "gnext-with-window")
    (stumpwm:define-key m (stumpwm:kbd "H") "gprev-with-window")
    (stumpwm:define-key m (stumpwm:kbd "m") "gmove")
    (stumpwm:define-key m (stumpwm:kbd "w") "grouplist")
    (stumpwm:define-key m (stumpwm:kbd "n") "gnew")
    (stumpwm:define-key m (stumpwm:kbd "q") "gkill")
    (stumpwm:define-key m (stumpwm:kbd "r") "grename")
    m))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-S") "gselect .κρυπτός") ;; hidden


(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "s-g") '*group-bindings*)
;; (stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "C-s-1") "")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-L") "gnext")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-H") "gprev")



;; Frame Configuration
(defvar *frame-bindings*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "r") "iresize")
    (stumpwm:define-key m (stumpwm:kbd "w") "all-windowlist-formatted")
    (stumpwm:define-key m (stumpwm:kbd "W") "windowlist")
    (stumpwm:define-key m (stumpwm:kbd "R") "title")
    (stumpwm:define-key m (stumpwm:kbd "b") "balance-frames")
    (stumpwm:define-key m (stumpwm:kbd "m") "mode-line")
    (stumpwm:define-key m (stumpwm:kbd "f") "fullscreen")
    (stumpwm:define-key m (stumpwm:kbd "F") "only")
    m))

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "s-f") '*frame-bindings*)
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "s-F") "fullscreen")


;; Volume // Brightness Config
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioLowerVolume") "volume-down")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioRaiseVolume") "volume-up")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioMute") "volume-mute")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioPlay") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioPrev") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioNext") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86MonBrightnessUp") "run-shell-command sudo xbacklight -inc 10")

(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86MonBrightnessDown") "run-shell-command sudo xbacklight -dec 10")
