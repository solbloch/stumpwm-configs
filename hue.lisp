(in-package :stumpwm)

(load "/home/sol/Projects/hue/hue.asd")
(ql:quickload :hue)

(defvar *lights*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "j") "decrement-bedroom-lights")
    (define-key m (kbd "k") "increment-bedroom-lights")
    (define-key m (kbd "K") "max-brightness-bedroom")
    (define-key m (kbd "o") "toggle-bedroom")
    (define-key m (kbd "i") "ilights")
    (loop for i from 1 to 5
          do (define-key m (kbd (format nil "~a" i))
               (format nil "set-bedroom-light ~a" (* 255 (/ i 5)))))
    m))

(define-key *top-map* (kbd "s-p") *lights*)


(define-interactive-keymap ilights ()
  ((kbd "j") "decrement-bedroom-lights")
  ((kbd "k") "increment-bedroom-lights"))

(defparameter *bridge* (hue::load-bridge))

(defparameter *bedroom* (find "my room" (hue:bridge-groups *bridge*)
                              :key #'hue::name :test #'string=))

(defun turn-off-group (group)
  (hue:set-state *bridge* group '(("on" . nil))))

(defun turn-on-group (group)
  (hue:set-state *bridge* group '(("on" . t))))

(defun toggle-group (group)
  (let ((on-p (cdr (assoc "any_on" (cdr
                                    (assoc "state" (cdr (hue:api-request
                                                         *bridge*
                                                         (format nil "groups/~a" (hue::group-number group))))
                                           :test #'string=))
                          :test #'string=))))
    (if on-p
        (turn-off-group group)
        (turn-on-group group))))

(defun get-group-brightness (group)
  (let ((alist-req (hue:api-request *bridge* (format nil "groups/~a" (hue::group-number group)))))
    (cdr (assoc "bri" (cdar alist-req) :test #'string=))))

(defun set-group-brightness (group brightness)
  (hue:set-state *bridge* group `(("bri" . ,brightness))))

(defun decrement-group-brightness (group)
  (let ((bri (get-group-brightness group)))
    (set-group-brightness group (abs (- bri 25)))))

(defun increment-group-brightness (group)
  (let ((bri (get-group-brightness group)))
    (set-group-brightness group (abs (+ bri 25)))))

(defcommand set-bedroom-light (num) ((:number "1-255: "))
  (set-group-brightness *bedroom* num))

(defcommand decrement-bedroom-lights () ()
  (decrement-group-brightness *bedroom*))

(defcommand increment-bedroom-lights () ()
  (increment-group-brightness *bedroom*))

(defcommand max-brightness-bedroom () ()
  (set-group-brightness *bedroom* 254))

(defcommand toggle-bedroom () ()
  (toggle-group *bedroom*))
