(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown))

(defvar *spotify-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") "copy-current-song-url")
    (define-key m (kbd "s") "search-track")
    m))

(defvar *spotify-menu-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") 'copy-song-url)
    m))

(define-key stumpwm:*top-map* (stumpwm:kbd "s-m") *spotify-keymap*)

(defun copy-song-url (menu)
  (set-x-selection (cadadr (nth (menu-selected menu) (menu-table menu))) :clipboard)
  (throw :menu-quit nil)
  (message "copied."))

(defvar scopes "user-read-playback-state user-read-recently-played user-read-currently-playing user-modify-playback-state")

(defvar *spotify-oauth* (lispotify:make-spotify-oauth id secret redirect scopes nil))

(defun authorization-header ()
  `(("Authorization"
     . ,(str:concat "Bearer " (jsown:val (lispotify:token *spotify-oauth*) "access_token")))))

(defun play-song (song-uri)
  (lispotify:with-token *spotify-oauth*
    (let ((uri-json (jsown:to-json `(:obj ("uris". (,song-uri))))))
      (dex:put "https://api.spotify.com/v1/me/player/play"
               :headers (authorization-header)
               :content uri-json))))

(defun search-track-func (name)
  "search a track and return a list of tracks in jsown object format"
  (lispotify:with-token *spotify-oauth*
    (let* ((uri (str:concat "https://api.spotify.com/v1/search?q="
                            (quri:url-encode name)
                            "&type=track"))
           (raw-results (handler-case
                            (dex:get uri
                                     :headers (authorization-header))
                          (dex:http-request-failed (e)
                            (format nil "~a" e)))))
      (jsown:val (jsown:val (jsown:parse raw-results) "tracks") "items"))))

(defcommand search-track (track) ((:string "track: "))
  (if (null track)
      (throw 'error "Abort.")
      (let* ((results (search-track-func track))
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
                       (,(jsown:val i "uri") ,(jsown:val (jsown:val i "album") "uri")
                        ,(jsown:val (jsown:val i "external_urls") "spotify")))))
             (choice (select-from-menu (current-screen)
                                       results-alist nil 0 *spotify-menu-keymap*)))
        (when choice
          (play-song (caadr choice))))))

(defun current-song ()
  (lispotify:with-token *spotify-oauth*
    (let ((request (dex:get "https://api.spotify.com/v1/me/player/currently-playing"
                            :headers (authorization-header))))
      (when (not (emptyp request))
        request))))

(defcommand copy-current-song-url () ()
  (lispotify:with-token *spotify-oauth*
    (let* ((current-song-data (current-song))
           (item-data (when (not (emptyp current-song-data))
                        (jsown:val (jsown:parse current-song-data) "item"))))
      (if item-data
          (progn (set-x-selection
                  (cdadr (jsown:val item-data "external_urls")) :clipboard)
                 (message (str:concat "Link to ^6" (jsown:val item-data "name")
                                      " - " (jsown:val (jsown:val item-data "album") "name")
                                      " ^7copied.")))
          (message "Nothing playing.")))))
