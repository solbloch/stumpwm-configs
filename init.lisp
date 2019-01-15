(in-package :stumpwm)

(load "~/quicklisp/setup.lisp")


;;; The following lines added by ql:add-to-init-file:
;;#-quicklisp
;;(let ((quicklisp-init #P"~/quicklisp/setup.lisp"))
;;  (when (probe-file quicklisp-init)
;;    (load quicklisp-init)))

(ql:quickload :clx-truetype)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4004
                     :style swank:*communication-style*
                     :dont-close t)

(load-module "swm-gaps")
;; packages !
(load-module "battery-portable") ; %B is battery
(load-module "cpu") ; use %c (CPU usage as %) %C (usage as bar graph) %t (temp) %f (frequency)
;;(load-module "wifi")  ; %l in the mode-line config
(load-module "ttf-fonts") ;fuck you ttf-fonts

(load "~/.stumpwm.d/looks.lisp")
(load "~/.stumpwm.d/functions.lisp")
(load "~/.stumpwm.d/vim.lisp")
(load "~/.stumpwm.d/keymap.lisp")


(set-prefix-key (kbd "C-M-t"))
(setf *mouse-focus-policy* :click)

;; :sloppy :click :ignore

(grename "phife")
(gnewbg "young thug")
(gnewbg ".κρυπτός")
