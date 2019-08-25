(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown))

(defvar *spotify-keymap*
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
                                       results-alist nil 0 *spotify-keymap*)))
        (if (null choice)
            nil
            (lispotify:play-spotify-uri (car (second choice)))))))

(define-key stumpwm:*top-map* (stumpwm:kbd "s-m") "search-track")
