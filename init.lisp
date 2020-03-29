(in-package :stumpwm)

(load "~/quicklisp/setup.lisp")

(ql:quickload '(:alexandria
                :bordeaux-threads
                :cl-async
                :cl-inotify
                :cl-ppcre
                :clx-truetype
                :jsown
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
(gnewbg "2")
(gnewbg "3")
(gnewbg "4")
(gnewbg "5")

;; (restore-from-file "/home/sol/.stumpwm.d/frames")

(mapcar #'load '("~/.stumpwm.d/async.lisp"
                 "~/.stumpwm.d/last-command.lisp"
                 "~/.stumpwm.d/process.lisp"
                 "~/.stumpwm.d/book.lisp"
                 "~/.stumpwm.d/config-sync.lisp"
                 "~/.stumpwm.d/token.lisp"
                 "~/.stumpwm.d/computer.lisp"
                 "~/.stumpwm.d/credentials.lisp"
                 "~/.stumpwm.d/spotify.lisp"
                 "~/.stumpwm.d/sound.lisp"
                 "~/.stumpwm.d/looks.lisp"
                 "~/.stumpwm.d/functions.lisp"
                 "~/.stumpwm.d/sudo.lisp"
                 "~/.stumpwm.d/vim.lisp"
                 "~/.stumpwm.d/greek.lisp"
                 "~/.stumpwm.d/scratchpad.lisp"
                 "~/.stumpwm.d/openvpn.lisp"
                 "~/.stumpwm.d/solb.lisp"
                 "~/.stumpwm.d/battery.lisp"
                 "~/.stumpwm.d/mode-line.lisp"
                 "~/.stumpwm.d/gaps-fullscreen.lisp"
                 "~/.stumpwm.d/ring.lisp"
                 "~/.stumpwm.d/clipboard-history.lisp"
                 "~/.stumpwm.d/next.lisp"
                 "~/.stumpwm.d/weather.lisp"
                 "~/.stumpwm.d/echo.lisp"
                 "~/.stumpwm.d/keymap.lisp"))


                 (set-prefix-key (kbd "C-M-t"))
                 (setf *mouse-focus-policy* :click)

                 ;; :sloppy :click :ignore
