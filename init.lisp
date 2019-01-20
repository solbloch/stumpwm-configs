(in-package :stumpwm)

(load "~/quicklisp/setup.lisp")

(ql:quickload :clx-truetype)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4004
                     :style swank:*communication-style*
                     :dont-close t)

(load-module "swm-gaps")
;; packages !
;; (load-module "battery-portable") ; %B is battery
(load-module "ttf-fonts") ;fuck you ttf-fonts

(mapcar #'load '("~/.stumpwm.d/looks.lisp"
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
