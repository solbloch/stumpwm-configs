(in-package :stumpwm)

(load "~/quicklisp/setup.lisp")

(ql:quickload '(:alexandria
                :bordeaux-threads
                :cl-async
                :cl-inotify
                :cl-ppcre
                :clx-truetype
                :swank
                :str
                :uiop
                :zpng))

(when *initializing*
  (run-shell-command "emacs --daemon")
  (require :swank)
  (swank-loader:init)
  (swank:create-server :port 4004
                       :style swank:*communication-style*
                       :dont-close t))

;; packages !
(mapcar #'load-module '("swm-gaps"
                        "ttf-fonts"
                        "net"))

(grename "1")
(gnew "2")
(gnew "3")
(gnew "4")

;; (restore-from-file "/home/sol/.stumpwm.d/frames")

(mapcar #'load '("~/.stumpwm.d/async.lisp"
                 "~/.stumpwm.d/book.lisp"
                 "~/.stumpwm.d/config-sync.lisp"
                 "~/.stumpwm.d/token.lisp"
                 "~/.stumpwm.d/computer.lisp"
                 "~/.stumpwm.d/spotify.lisp"
                 "~/.stumpwm.d/sound.lisp"
                 "~/.stumpwm.d/looks.lisp"
                 "~/.stumpwm.d/functions.lisp"
                 "~/.stumpwm.d/sudo.lisp"
                 "~/.stumpwm.d/vim.lisp"
                 "~/.stumpwm.d/greek.lisp"
                 "~/.stumpwm.d/scratchpad.lisp"
                 "~/.stumpwm.d/openvpn.lisp"
                 "~/.stumpwm.d/keymap.lisp"
                 "~/.stumpwm.d/solb.lisp"
                 "~/.stumpwm.d/battery.lisp"
                 "~/.stumpwm.d/mode-line.lisp"
                 "~/.stumpwm.d/gaps-fullscreen.lisp"
                 "~/.stumpwm.d/auto-tile.lisp"
                 "~/.stumpwm.d/next.lisp"))


(set-prefix-key (kbd "C-M-t"))
(setf *mouse-focus-policy* :click)

;; :sloppy :click :ignore
