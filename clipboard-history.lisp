(in-package :stumpwm)

(defvar *clipboard-history-size* 50)

(defvar *clipboard-menu-max-length* 60)

(defvar *clipboard-ring* (make-ring :size *clipboard-history-size*))

(defun post-text (menu)
  (let ((text (cadr (nth (menu-selected menu) (menu-table menu)))))
    (bt:make-thread
     (lambda ()
       (catch-host-not-found
         (set-x-selection (post text "text/plain") :clipboard)
         (message "Copied link to clipboard."))))
    (throw :menu-quit nil)))

(defun show-text (menu)
  (let ((text (cadr (nth (menu-selected menu) (menu-table menu)))))
    (message text)
    (sleep .8)))

(defvar *clipboard-menu-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") #'post-text)
    (define-key m (kbd "TAB") #'show-text)
    m))

(defun remember-clipboard ()
  (let ((clip-string (get-x-selection nil :clipboard)))
    (when (not (find clip-string (items *clipboard-ring*) :test #'string=))
      (insert *clipboard-ring* clip-string))))


(defun clipboard-alist ()
  (let ((clipboard-items (recent-list *clipboard-ring*)))
    (mapcar #'(lambda (text)
              (list (if (< (length text) *clipboard-menu-max-length*)
                        text
                        (str:concat (subseq text 0 (1- *clipboard-menu-max-length*))
                                    "..."))
                    text))
            clipboard-items)))

(defcommand clipboard () ()
  (let ((choice (select-from-menu (current-screen)
                                  (remove nil (clipboard-alist))
                                  nil 0 *clipboard-menu-keymap*)))
    (when choice
        (set-x-selection (cadr choice) :clipboard))))

