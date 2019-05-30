(in-package :stumpwm)

(load "~/quicklisp/setup.lisp")

(ql:quickload :clx-truetype)
(ql:quickload :swank)


(if *initializing*
    (progn
      (require :swank)
      (swank-loader:init)
      (swank:create-server :port 4004
                           :style swank:*communication-style*
                           :dont-close t)))

;; packages !
(load-module "swm-gaps")
(load-module "ttf-fonts") ;fuck you ttf-fonts you broke my config you evil evil rendering

(mapcar #'load '("~/.stumpwm.d/async.lisp"
                 "~/.stumpwm.d/book.lisp"
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
                 "~/.stumpwm.d/mode-line.lisp"))


(set-prefix-key (kbd "C-M-t"))
(setf *mouse-focus-policy* :click)

;; :sloppy :click :ignore

(grename "phife")
(gnewbg "q-tip")
(gnewbg "ali")
(gnewbg "jarobi")
