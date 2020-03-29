(in-package :stumpwm)

(defvar *command-history* '())
(defvar *menu-command-history* '())

(defun remember-history (command)
  (push command *command-history*))

(defun remember-menu (menu)
  (push (list menu (car *command-history*)) *menu-command-history*))

(when *initializing*
  (add-hook *pre-command-hook* #'remember-history)
  (add-hook *menu-selection-hook* #'remember-menu))

(defvar *repeating* nil)
(defun with-menu-context-repeat ()
  (setf *repeating* t)
  (funcall (cadar *menu-command-history*))
  (setf *repeating* nil))

(defcommand repeat-last-menu-command () ()
  (with-menu-context-repeat))

(defun select-from-menu (screen table &optional (prompt "Search:")
                                        (initial-selection 0)
                                        extra-keymap
                                        (filter-pred #'menu-item-matches-regexp))
  (check-type screen screen)
  (check-type table (or (cons string) (cons cons)))
  (check-type prompt (or null string))
  (check-type initial-selection integer)
  ;; if repeating a command, return last choice
  (if *repeating*
      (let ((last-menu-command (car *menu-command-history*)))
        (nth (menu-selected (car last-menu-command)) (menu-table (car last-menu-command))))
      (when table
        (let ((menu (make-instance 'single-menu
                                   :table (if (every #'listp table)
                                              table
                                              (mapcar #'list table))
                                   :selected initial-selection
                                   :prompt prompt
                                   :view-start 0
                                   :view-end 0
                                   :additional-keymap extra-keymap
                                   :FILTER-PRED filter-pred)))
          (run-menu screen menu)))))
