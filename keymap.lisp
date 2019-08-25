(in-package :stumpwm)

;; this is the best thing VIMIFY :-)
(define-key *input-map* (stumpwm:kbd "C-w") 'stumpwm::input-backward-kill-word)


;; top map stuff
(define-key *top-map* (stumpwm:kbd "s-A") "audio-switch")
(define-key *top-map* (stumpwm:kbd "s-v") "hsplit")
(define-key *top-map* (stumpwm:kbd "s-s") "vsplit")
(define-key *top-map* (stumpwm:kbd "s-r") "remove")
(define-key *top-map* (stumpwm:kbd "s-q") "delete")
(define-key *top-map* (stumpwm:kbd "s-Q") "killandremove")
(define-key *top-map* (stumpwm:kbd "s-n") "pull-hidden-next")
(define-key *top-map* (stumpwm:kbd "s-p") "pull-hidden-previous")
(define-key *top-map* (stumpwm:kbd "M-TAB") "fnext")
(define-key *top-map* (stumpwm:kbd "M-`") "pull-hidden-next")
(define-key *top-map* (stumpwm:kbd "s-RET") "run-shell-command st")
(define-key *top-map* (stumpwm:kbd "M-S") "scratchpad") ;; hidden
;; (define-key *top-map* (stumpwm:kbd "M-L") "gnext")
;; (define-key *top-map* (stumpwm:kbd "M-H") "gprev")
(define-key *top-map* (stumpwm:kbd "s-G") "greek-menu")
(define-key *top-map* (stumpwm:kbd "s-F") "fullscreen")
(define-key *top-map* (stumpwm:kbd "s-b") "open-book")

(define-key *top-map* (stumpwm:kbd "s-`") "gselect -1")
(define-key *top-map* (stumpwm:kbd "s-1") "gselect 1")
(define-key *top-map* (stumpwm:kbd "s-2") "gselect 2")
(define-key *top-map* (stumpwm:kbd "s-3") "gselect 3")
(define-key *top-map* (stumpwm:kbd "s-4") "gselect 4")
(define-key *top-map* (stumpwm:kbd "s-5") "gselect 5")
(define-key *top-map* (stumpwm:kbd "M-H") "gselect -1")
(define-key *top-map* (stumpwm:kbd "M-J") "gselect 1")
(define-key *top-map* (stumpwm:kbd "M-K") "gselect 2")
(define-key *top-map* (stumpwm:kbd "M-L") "gselect 3")
;; (define-key *top-map* (stumpwm:kbd "M-:") "gselect 4")

(define-key *top-map* (stumpwm:kbd "M-w") '*helpful-things*)
(define-key *top-map* (stumpwm:kbd "s-S") '*solb-commands*)
(define-key *top-map* (stumpwm:kbd "s-c") '*vpn-commands*)
(define-key *top-map* (stumpwm:kbd "M-A") '*looks-feels*)
(define-key *top-map* (stumpwm:kbd "s-g") '*group-bindings*)
(define-key *top-map* (stumpwm:kbd "s-f") '*frame-bindings*)
(define-key *top-map* (stumpwm:kbd "s-a") '*application-bindings*)


;; Applications ;;
(defvar *application-bindings*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "e") "emacs-fixed")
    (stumpwm:define-key m (stumpwm:kbd "u") "run-shell-command 'st'")
    (stumpwm:define-key m (stumpwm:kbd "s") "spotify")
    (stumpwm:define-key m (stumpwm:kbd "c") "run-shell-command google-chrome-stable")
    (stumpwm:define-key m (stumpwm:kbd "r") "ripcord")
    (stumpwm:define-key m (stumpwm:kbd "d") "run-shell-command dolphin")
    (stumpwm:define-key m (stumpwm:kbd "D") "darktable")
    (stumpwm:define-key m (stumpwm:kbd "t") "telegram")
    m))


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
    (stumpwm:define-key m (stumpwm:kbd "s") "fselect")
    (stumpwm:define-key m (stumpwm:kbd "F") "only")
    m))


;; Looks Feels
(defvar *looks-feels*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "y") "yoshis")
    (stumpwm:define-key m (stumpwm:kbd "b") "bf")
    (stumpwm:define-key m (stumpwm:kbd "F") "fod")
    (stumpwm:define-key m (stumpwm:kbd "f") "fd")
    (stumpwm:define-key m (stumpwm:kbd "d") "dl")
    (stumpwm:define-key m (stumpwm:kbd "j") "jupiter")
    m))


;; Helpful Things
(defvar *helpful-things*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "g") "toggle-gaps")
    (stumpwm:define-key m (stumpwm:kbd "s") "second-screen")
    (stumpwm:define-key m (stumpwm:kbd "r") '*redshift-levels*)
    m))


;; Redshift Configs
(defvar *redshift-levels*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "1") "redshift-temp 5500")
    (stumpwm:define-key m (stumpwm:kbd "2") "redshift-temp 4500")
    (stumpwm:define-key m (stumpwm:kbd "3") "redshift-temp 3500")
    (stumpwm:define-key m (stumpwm:kbd "4") "redshift-temp 2500")
    (stumpwm:define-key m (stumpwm:kbd "0") "exec redshift -x")
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

;; Volume // Brightness Config
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioLowerVolume") "volume-down")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioRaiseVolume") "volume-up")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioMute") "volume-mute")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioPlay") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioPrev") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioNext") "run-shell-command dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") (stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86MonBrightnessUp") "run-shell-command sudo xbacklight -inc 10")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86MonBrightnessDown") "run-shell-command sudo xbacklight -dec 10")
