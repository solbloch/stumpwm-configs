(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown))

(define-key stumpwm:*top-map* (stumpwm:kbd "s-m") *spotify-keymap*)

(defvar *spotify-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") "copy-current-song-url")
    (define-key m (kbd "s") "search-track")
    m))

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

(defcommand copy-current-song-url () ()
  (let ((raw-output
          (run-shell-command
           "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:\"org.mpris.MediaPlayer2.Player\" string:'Metadata' | grep -Eo '(\"(.*)\")|(\b[0-9][a-zA-Z0-9.]*\b)'" t)))
    (set-x-selection
     (str:substring 1 -1 (first (last (cl-ppcre:all-matches-as-strings "\"(.*)\"" raw-output))))
     :clipboard)))
