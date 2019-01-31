(in-package :stumpwm)

(load "/home/sol/Documents/lispotify/lispotify.asd")

(ql:quickload :lispotify)
(ql:quickload :jsown)
(ql:quickload :)

(defun search-menu (item-string item-object user-input)
  (declare (ignore item-object))
  (search (string-downcase user-input)
          (string-downcase item-string)))

(defcommand search-track (track) ((:string "track: "))
  (let* ((results (lispotify:search-track track))
         (results-alist (loop for i in results
                              collecting
                              `(,(concatenate 'string (jsown:val i "name") " - "
                                              (format nil "~{~a~^ & ~}"
                                                      (loop for artist in (jsown:val i "artists")
                                                            collecting (jsown:val artist "name"))))
                                 ,(jsown:val i "uri"))))
         (choice (select-from-menu (current-screen)
                                   results-alist nil 0 nil #'search-menu)))
    (lispotify:play-spotify-uri (second choice))))
