(in-package :stumpwm)

(defun screenshot-drawable (drawable file &key
                                            (height (xlib:drawable-height drawable))
                                            (width (xlib:drawable-width drawable))
                                            (x 0)
                                            (y 0))
  "non-faithfully taken from the screenshot module (added x and y coordinates, and use loop so I can read it better)"
  (let ((png (make-instance 'zpng:pixel-streamed-png
                            :color-type :truecolor
                            :width width
                            :height height)))
    (multiple-value-bind (pixarray depth visual)
        (xlib:get-raw-image drawable :x x :y y :width width :height height
                                     :format :z-pixmap)
      (declare (ignore depth visual))
      (with-open-file (stream file
                              :direction :output
                              :if-exists :supersede
                              :if-does-not-exist :create
                              :element-type '(unsigned-byte 8))
        (zpng:start-png png stream)
        (case (xlib:display-byte-order (xlib:drawable-display drawable))
          (:lsbfirst (loop for i from 0 below (length pixarray) by 4
                           do (zpng:write-pixel (list (aref pixarray (+ 2 i))
                                                      (aref pixarray (+ 1 i))
                                                      (aref pixarray  i))
                                                png)))
          (:msbfirst (loop for i from 0 below (* height width 4) by 4
                           do (zpng:write-pixel (list (aref pixarray (1+ i))
                                                      (aref pixarray (+ 2 i))
                                                      (aref pixarray (+ 3 i)))
                                                png))))
        (zpng:finish-png png)))))

(defun screenshot-selection (filename)
  (let* (point-one
         point-two
         canceled
         (cursor-font (xlib:open-font *display* *grab-pointer-font*))
         (cursor (xlib:create-glyph-cursor
                  :source-font cursor-font
                  :source-char 34
                  :mask-font cursor-font
                  :mask-char 35
                  :foreground
                  (lookup-color (current-screen) "Black")
                  :background (lookup-color (current-screen) "White"))))
    (xlib:grab-keyboard (screen-root (current-screen)))
    (xlib:grab-pointer (screen-root (current-screen))
                       (xlib:make-event-mask :button-press)
                       :cursor cursor)
    (loop until (or canceled (and point-one point-two))
          do (xlib:event-case (*display*)
                              (:button-press
                               ()
                               (if (null point-one)
                                   (setf point-one (multiple-value-list
                                                    (xlib:global-pointer-position *display*)))
                                   (setf point-two (multiple-value-list
                                                    (xlib:global-pointer-position *display*)))))
                              (:key-press
                               ()
                               (setf canceled t)))
          finally (when (not canceled)
                    (let ((x-one (car point-one))
                          (y-one (cadr point-one))
                          (x-two (car point-two))
                          (y-two (cadr point-two)))
                      (screenshot-drawable (xlib:screen-root (screen-number (current-screen)))
                                           filename
                                           :x (min x-one x-two)
                                           :y (min y-one y-two)
                                           :width (abs (- x-one x-two))
                                           :height (abs (- y-one y-two))))))
    (xlib:ungrab-pointer *display*)
    (xlib:ungrab-keyboard *display*)))

(defun screenshot-full
    (filename)
  (screenshot-drawable (xlib:screen-root (screen-number (current-screen))) filename))

(defun post (data type)
  (dex:post "https://backend.solb.io/fileupload"
            :content `(("file"  . ,data)
                       ("token" . ,*solb-token*)
                       ("type"  . ,type))))

(defun post-redirect (link)
  (dex:post "https://backend.solb.io/shorten"
            :content `(("redirect"  . ,link)
                       ("token" . ,*solb-token*))))

(defmacro catch-host-not-found (&body body)
  `(handler-case (progn ,@body)
     (usocket:ns-host-not-found-error ()
       (message "host-not-found"))))

(defcommand screenshot-selection-post () ()
  (screenshot-selection "~/.stumpwm.d/tempfile.png")
  (bt:make-thread
   (lambda ()
     (catch-host-not-found
      (set-x-selection (post #P"~/.stumpwm.d/tempfile.png" "image/png") :clipboard)
      (message "Copied link to clipboard.")))))

(defcommand screenshot-selection-copy () ()
  (screenshot-selection "~/.stumpwm.d/tempfile.png")
  (bt:make-thread
   (lambda ()
      (run-shell-command "xclip -selection clipboard -t image/png -i ~/.stumpwm.d/tempfile.png")
      (message "Copied PHOTO to clipboard."))))

(defcommand screenshot-full-post () ()
  (screenshot-full "~/.stumpwm.d/tempfile.png")
  (bt:make-thread
   (lambda ()
     (catch-host-not-found
      (set-x-selection (post #P"~/.stumpwm.d/tempfile.png" "image/png") :clipboard)
      (message "Copied link to clipboard.")))))

(defcommand post-clipboard-text () ()
  (let ((clipboard (get-x-selection nil :clipboard)))
    (bt:make-thread
     (lambda ()
       (catch-host-not-found
        (set-x-selection (post clipboard "text/plain") :clipboard)
        (message "Copied link to clipboard."))))))

(defcommand post-clipboard-redirect () ()
  (let ((clipboard (get-x-selection nil :clipboard)))
    (bt:make-thread
     (lambda ()
       (catch-host-not-found (set-x-selection (post clipboard "redirect") :clipboard)
         (message "Copied link to clipboard."))))))

(defcommand ssh-pull-and-reload () ()
  (run-shell-command "ssh sol@solb.io bash /home/sol/scripts/updatebash"))
