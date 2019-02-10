(in-package :stumpwm)

(ql:quickload :uiop)

(defvar *vpn-dirs* (uiop:subdirectories #P"~/GOOGLE/vpn"))

(defvar *live-vpns* "")

(defun vpn-connect (vpn-path (&key ))
  (sudo-shell )
