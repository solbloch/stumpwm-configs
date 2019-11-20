(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown))

(defvar *spotify-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") "copy-current-song-url")
    (define-key m (kbd "s") "search-track")
    m))

(define-key stumpwm:*top-map* (stumpwm:kbd "s-m") *spotify-keymap*)

(defvar *spotify-menu-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") 'copy-song-url)
    m))

(defun copy-song-url (menu)
  (set-x-selection (cadadr (nth (menu-selected menu) (menu-table menu))) :clipboard)
  (throw :menu-quit nil)
  (message "copied."))


(defcommand search-track (track) ((:string "track: "))
  (if (null track)
      (throw 'error "Abort.")
      (let* ((results (lispotify:search-track track))
             (results-alist
               (loop for i in results
                     collecting
                     `(,(str:concat (jsown:val i "name") " - "
                                    (jsown:val (jsown:val i "album")
                                               "name")
                                    " - "
                                    (format nil "~{~a~^ & ~}"
                                            (loop for artist in (jsown:val i "artists")
                                                  collecting (jsown:val artist "name"))))
                       (,(jsown:val i "uri") ,(jsown:val (jsown:val i "external_urls") "spotify")))))
             (choice (select-from-menu (current-screen)
                                       results-alist nil 0 *spotify-menu-keymap*)))
        (if (null choice)
            nil
            (lispotify:play-spotify-uri (car (second choice)))))))

(defcommand spotify-metadata () ()
  (let* ((raw-output
           (run-shell-command
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:\"org.mpris.MediaPlayer2.Player\" string:'Metadata'" t))
         (split (cl-ppcre:all-matches-as-strings "(string|double|int32|uint64)(.*)" raw-output))
         (type-less (mapcar (lambda (x) (cl-ppcre:regex-replace-all
                                          "(string|double|int32|uint64) (.*)"
                                          x "\\2")) split))
         (cleaned (mapcar (lambda (x) (remove #\" (cl-ppcre:regex-replace-all
                                        "(mpris:|xesam:)(.*)"
                                        x "\\2"))) type-less)))
    (loop for i from 0 to (1- (length cleaned)) by 2
          collecting (cons (nth i cleaned) (nth (1+ i) cleaned)))))

(defcommand copy-current-song-url () ()
  (let ((metadata (spotify-metadata)))
    (set-x-selection (cdr (assoc "url" metadata :test #'string=)) :clipboard)
    (echo (str:concat "Link to ^6" (cdr (assoc "title" metadata :test #'string=))
                      " - " (cdr (assoc "artist" metadata :test #'string=))
                      " ^7copied."))))
