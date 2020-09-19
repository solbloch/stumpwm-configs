(in-package :stumpwm)

;; this is the best thing VIMIFY :-)
(define-key *input-map* (kbd "C-w") 'input-backward-kill-word)


;; top map stuff
(define-key *top-map* (kbd "s-A") "audio-switch")
(define-key *top-map* (kbd "s-v") "hsplit")
(define-key *top-map* (kbd "s-s") "vsplit")
(define-key *top-map* (kbd "s-r") "remove")
(define-key *top-map* (kbd "s-q") "delete")
(define-key *top-map* (kbd "s-Q") "killandremove")
(define-key *top-map* (kbd "s-n") "pull-hidden-next")
(define-key *top-map* (kbd "M-`") "pull-hidden-next")
(define-key *top-map* (kbd "s-p") "pull-hidden-previous")
(define-key *top-map* (kbd "s-RET") "run-shell-command st")
(define-key *top-map* (kbd "s-e") "emoji-picker")
(define-key *top-map* (kbd "s-G") "greek-menu")
(define-key *top-map* (kbd "s-F") "fullscreen")
(define-key *top-map* (kbd "s-b") "open-book")
(define-key *top-map* (kbd "s-c") "clipboard")

(define-key *top-map* (kbd "s-`") "gselect -1")
(define-key *top-map* (kbd "s-1") "gselect 1")
(define-key *top-map* (kbd "s-2") "gselect 2")
(define-key *top-map* (kbd "s-3") "gselect 3")
(define-key *top-map* (kbd "s-4") "gselect 4")
(define-key *top-map* (kbd "s-5") "gselect 5")

(define-key *top-map* (kbd "s-w") '*helpful-things*)
(define-key *top-map* (kbd "s-S") '*solb-commands*)
(define-key *top-map* (kbd "s-x") '*vpn-commands*)
(define-key *top-map* (kbd "s-A") '*looks-feels*)
(define-key *top-map* (kbd "s-g") '*group-bindings*)
(define-key *top-map* (kbd "s-f") '*frame-bindings*)
(define-key *top-map* (kbd "s-a") '*application-bindings*)
(define-key *top-map* (kbd "s-t") '*terminal-bindings*)

;; Applications ;;
(defvar *application-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "e") "emacs-fixed")
    (define-key m (kbd "u") "run-shell-command st")
    (define-key m (kbd "s") "spotify")
    (define-key m (kbd "c") "run-shell-command firefox")
    (define-key m (kbd "r") "ripcord")
    (define-key m (kbd "d") "run-shell-command discord-canary")
    (define-key m (kbd "D") "darktable")
    (define-key m (kbd "t") "telegram")
    (define-key m (kbd "v") "run-shell-command pavucontrol")
    m))


;; Group Configuration ;;
(defvar *group-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "h") "gprev")
    (define-key m (kbd "l") "gnext")
    (define-key m (kbd "L") "gnext-with-window")
    (define-key m (kbd "H") "gprev-with-window")
    (define-key m (kbd "m") "gmove")
    (define-key m (kbd "w") "grouplist")
    (define-key m (kbd "n") "gnew")
    (define-key m (kbd "q") "gkill")
    (define-key m (kbd "r") "grename")
    m))


;; Frame Configuration
(defvar *frame-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "r") "iresize")
    (define-key m (kbd "w") "all-windowlist-formatted")
    (define-key m (kbd "W") "windowlist")
    (define-key m (kbd "R") "title")
    (define-key m (kbd "b") "balance-frames")
    (define-key m (kbd "m") "mode-line")
    (define-key m (kbd "f") "fullscreen")
    (define-key m (kbd "s") "fselect")
    (define-key m (kbd "F") "only")
    m))


;; Looks Feels
(defvar *looks-feels*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "y") "yoshis")
    (define-key m (kbd "b") "bf")
    (define-key m (kbd "F") "fod")
    (define-key m (kbd "f") "fd")
    (define-key m (kbd "d") "dl")
    (define-key m (kbd "j") "jupiter")
    m))


;; Helpful Things
(defvar *helpful-things*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "g") "toggle-gaps")
    (define-key m (kbd "s") "second-screen")
    (define-key m (kbd "r") '*redshift-levels*)
    (define-key m (kbd "f") "fix-discord")
    m))


;; Redshift Configs
(defvar *redshift-levels*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "1") "redshift-temp 5500")
    (define-key m (kbd "2") "redshift-temp 4500")
    (define-key m (kbd "3") "redshift-temp 3500")
    (define-key m (kbd "4") "redshift-temp 2500")
    (define-key m (kbd "0") "exec redshift -x")
    m))

;; VPN
(defvar *vpn-commands*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "c") "connect-vpn-menu")
    (define-key m (kbd "k") "kill-vpn-menu")
    m))

;; solb
(defvar *solb-commands*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "s") "screenshot-selection-post")
    (define-key m (kbd "S") "screenshot-selection-copy")
    (define-key m (kbd "f") "screenshot-full-post")
    (define-key m (kbd "c") "post-clipboard-text")
    (define-key m (kbd "r") "post-clipboard-redirect")
    (define-key m (kbd "C-r") "ssh-pull-and-reload")
    m))

;; Terminal bindings
(defvar *terminal-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "s") "run-shell-command st -e ssh sol@solb.io")
    m))

;; Volume // Brightness Config
(define-key *top-map* (kbd "XF86AudioLowerVolume") "volume-down")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "volume-up")
(define-key *top-map* (kbd "XF86AudioMute") "volume-mute")
(define-key *top-map* (kbd "XF86AudioPlay") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
(define-key *top-map* (kbd "XF86AudioPrev") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
(define-key *top-map* (kbd "XF86AudioNext") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "run-shell-command xbacklight -inc 5")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "run-shell-command xbacklight -dec 5")
