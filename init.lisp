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
(load-module "ttf-fonts") ;fuck you ttf-fonts

(mapcar #'load '("~/.stumpwm.d/computer.lisp"
                 "~/.stumpwm.d/mode-line.lisp"
                 "~/.stumpwm.d/spotify.lisp"
                 "~/.stumpwm.d/sound.lisp"
                 "~/.stumpwm.d/looks.lisp"
                 "~/.stumpwm.d/functions.lisp"
                 "~/.stumpwm.d/password.lisp"
                 "~/.stumpwm.d/vim.lisp"
                 "~/.stumpwm.d/keymap.lisp"))


(set-prefix-key (kbd "C-M-t"))
(setf *mouse-focus-policy* :click)

;; :sloppy :click :ignore

(grename "phife")
(gnewbg "young thug")
(gnewbg ".κρυπτός")
