(in-package :stumpwm)

;; (defun vertical-tile (win)
;;   (split-frame-v (current-group)))

;; (balance-frames)


(remove-hook *new-window-hook* 'auto-tile)

(defun auto-tile (win)
  (recursive-tile-head (length (head-windows (current-group)
                                             (current-head)))))

(defun recursive-tile-head (n &optional
                                (group (current-group))
                                (head (current-head)))
  "Find the largest (by area) frame in the group, split it in half
vertically or horizontally depending on which is dimension is larger.
Repeat until there is only one window left."
  (unless (<= n 1)
    (let* ((frames (head-frames group head))
           (areas (frame-area frames))
           (idx (position (reduce #'max areas) areas))
           (frame (nth idx frames))
           (w (frame-width frame))
           (h (frame-height frame)))
      (focus-frame group frame)
      (if (< w h)
          (vsplit)
          (hsplit)))
    (recursive-tile-head (- n 1) group head)))
