(in-package :stumpwm)

;; (remove-hook *new-window-hook* 'auto-tile)

(defun auto-tile (win)
  (recursive-tile-head (length (head-windows (current-group) (current-head)))))

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

(defun tile-function (n &optional
                 (group (current-group))
                 (head (current-head)))
  (let* ((frames (head-frames group head))
         (areas (frame-area frames))
         (idx (position (reduce #'max areas) areas))
         (frame (nth idx frames))
         (w (frame-width frame))
         (h (frame-height frame)))
    ))

(defcommand head-show () ()
  (let ((windows (head-windows (current-group) (current-head))))
    (message "~a" windows)))

(defun pull-window (win &optional (to-frame (tile-group-current-frame (window-group win))) (focus-p t))
  (let ((f (window-frame win))
        (group (window-group win)))
    (unless (eq (frame-window to-frame) win)
      (xwin-hide win)
      (setf (window-frame win) to-frame)
      (maximize-window win)
      (when (eq (window-group win) (current-group))
        (xwin-unhide (window-xwin win) (window-parent win)))
      ;; We have to restore the focus after hiding.
      (when (eq win (screen-focus (window-screen win)))
        (screen-set-focus (window-screen win) win))
      (frame-raise-window group to-frame win focus-p)
      ;; if win was focused in its old frame then give the old
      ;; frame the frame's last focused window.
      (when (eq (frame-window f) win)
        ;; the current value is no longer valid.
        (setf (frame-window f) nil)
        (frame-raise-window group f (first (frame-windows group f)) nil)))))
