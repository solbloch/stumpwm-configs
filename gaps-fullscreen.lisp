(in-package :swm-gaps)

(defun apply-gaps-p (win)
  "Tell if gaps should be applied to this window"
  (and *gaps-on* (not (stumpwm::window-transient-p win)) (not (window-fullscreen win))))
