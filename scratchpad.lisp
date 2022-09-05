(defvar *floating-win* nil)
(defvar *past-group* nil)
(defvar *past-frame* nil)

(defun push-back-hook (curr last)
  (declare (ignorable last))
  (if (not (equal curr *floating-win*))
      (push-back *floating-win*)))

(defun pop-here (win)

  ;; store old group and frame
  (setf *past-group* (window-group win))
  (setf *past-frame* (window-frame win))
  (setf *floating-win* win)

  ;; move over to the new group and new frame
  (move-window-to-group win (current-group))
  (pull-window win (window-frame (current-window)))
  (float-window win (current-group))

  (float-window-move-resize win :x (/ (- 1920 1000) 2) :y (/ (- 1080 750) 2) :width 1000 :height 750)

  ;; add hooks and keymap alt-tab to push back the window.
  ;; hook called with two arguments, current and last window
  (add-hook *focus-window-hook* #'push-back-hook))

(defun push-back (win)
  (unfloat-window win (current-group))
  (move-window-to-group win *past-group*)
  (pull-window win *past-frame*)
  (remove-hook *focus-window-hook* #'push-back-hook))

(defcommand scratch-windowlist (&optional (fmt "%c - %s%300t")
                            window-list) (:rest)
  (let ((window-list (or window-list
                         (sort-windows-by-number
                          (screen-windows (current-screen))))))
    (if (null window-list)
        (message "No Managed Windows")
        (let ((window (select-window-from-menu window-list fmt)))
          (if window
              (pop-here window)
              (throw 'error :abort))))))
