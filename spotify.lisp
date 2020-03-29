(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown))

(defvar *spotify-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") "copy-current-song-url")
    (define-key m (kbd "s") "search-track")
    (define-key m (kbd "p") "play-playlist")
    (define-key m (kbd "a") "add-current-song-playlist")
    (define-key m (kbd "TAB") "echo-current-song")
    (define-key m (kbd "Right") "skip-forward")
    (define-key m (kbd "Left") "skip-backward")
    m))

(defvar *spotify-menu-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") 'copy-url)
    m))

(define-key stumpwm:*top-map* (stumpwm:kbd "s-m") *spotify-keymap*)

(defun copy-url (menu)
  (set-x-selection (third (second (nth (menu-selected menu) (menu-table menu)))) :clipboard)
  (throw :menu-quit nil)
  (message "Copied."))

(defvar scopes "user-read-playback-state user-read-recently-played user-read-currently-playing user-modify-playback-state playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private")

(defvar *spotify-oauth* (lispotify:make-spotify-oauth id secret redirect scopes nil))

(defmacro multi-val (object &rest vals)
  (if vals
      `(jsown:val (multi-val ,object ,@(butlast vals)) ,(car (last vals)))
      object))

(defun authorization-header ()
  `(("Authorization"
     . ,(str:concat "Bearer " (jsown:val (lispotify:token *spotify-oauth*) "access_token")))))

(defun get-playlists ()
  (let ((raw-results (lispotify:with-token *spotify-oauth*
                       (dex:get "https://api.spotify.com/v1/me/playlists?limit=50"
                                :headers (authorization-header)))))
    (loop for playlist in (jsown:val (jsown:parse raw-results) "items")
          collecting (list (format nil "^5~a^7 [~a (~a)]"
                                   (jsown:val playlist "name")
                                   (multi-val playlist "owner" "display_name")
                                   (multi-val playlist "owner" "id"))
                           (list (jsown:val playlist "uri") (jsown:val playlist "id")
                                 (multi-val playlist "external_urls" "spotify"))))))

(defun add-song-to-playlist (song-uri playlist-id)
  (lispotify:with-token *spotify-oauth*
    (dex:post (format nil "https://api.spotify.com/v1/playlists/~a/tracks" playlist-id)
              :headers (authorization-header)
              :content (jsown:to-json `(:obj ("uris" . (,song-uri)))))))

(defun get-currently-playing ()
  (lispotify:with-token *spotify-oauth*
    (let ((request (dex:get "https://api.spotify.com/v1/me/player/currently-playing"
                            :headers (authorization-header))))
      (if (emptyp request)
          (throw 'error "Nothing playing.")
          (jsown:parse request)))))

(defun play-context-uri (context-uri)
  (lispotify:with-token *spotify-oauth*
    (dex:put "https://api.spotify.com/v1/me/player/play"
             :headers (authorization-header)
             :content (jsown:to-json `(:obj ("context_uri". ,context-uri))))))

(defun play-song (song-uri)
  (lispotify:with-token *spotify-oauth*
    (dex:put "https://api.spotify.com/v1/me/player/play"
             :headers (authorization-header)
             :content (jsown:to-json `(:obj ("uris". (,song-uri)))))))

(defun search-track-func (name)
  "search a string and return a list of tracks in jsown object format"
  (lispotify:with-token *spotify-oauth*
    (let* ((uri (str:concat "https://api.spotify.com/v1/search?q="
                            (quri:url-encode name)
                            "&type=track"))
           (raw-results (handler-case
                            (dex:get uri
                                     :headers (authorization-header))
                          (dex:http-request-failed (e)
                            (format nil "~a" e)))))
      (multi-val (jsown:parse raw-results) "tracks" "items"))))

(defun track-string (song-item)
  (format nil "~a - ~a - ~{~a~^, ~}"
          (jsown:val song-item "name")
          (multi-val song-item "album" "name")
          (loop for artist in (jsown:val song-item "artists")
                collecting (jsown:val artist "name"))))

;; Commands
(defcommand search-track (track) ((:string "Track: "))
  (when track
    (let* ((results (search-track-func track))
           (results-alist
             (loop for i in results
                   collecting
                   (list (track-string i)
                         (list (jsown:val i "uri") (multi-val i "album" "uri")
                               (multi-val i "external_urls" "spotify")))))
           (choice (select-from-menu (current-screen) results-alist nil 0
                                     *spotify-menu-keymap*)))
      (when choice
        (play-song (caadr choice))))))

(defcommand play-playlist () ()
  (let* ((playlists (get-playlists))
         (choice (select-from-menu (current-screen) playlists nil 0 *spotify-menu-keymap*)))
    (when choice
      (play-context-uri (caadr choice)))))

(defcommand echo-current-song () ()
  (let* ((currently-playing (jsown:val (get-currently-playing) "item")))
    (message "Listening to ^6~a^7."
             (track-string currently-playing))))

(defcommand copy-current-song-url () ()
  (let* ((currently-playing (jsown:val (get-currently-playing) "item")))
    (progn (set-x-selection
            (cdadr (jsown:val currently-playing "external_urls")) :clipboard)
           (message "Link to ^6~a^7 copied."
                    (track-string currently-playing)))))

(defcommand skip-forward () ()
  (lispotify:with-token *spotify-oauth*
    (dex:post "https://api.spotify.com/v1/me/player/next"
              :headers (authorization-header))))

(defcommand skip-backward () ()
  (lispotify:with-token *spotify-oauth*
    (dex:post "https://api.spotify.com/v1/me/player/previous"
              :headers (authorization-header))))

(defcommand add-current-song-playlist () ()
  (let* ((currently-playing (jsown:val (get-currently-playing) "item"))
         (playlists (get-playlists))
         (choice (select-from-menu (current-screen) playlists
                                    (format nil "Add to ^6~a^7 to which playlist?"
                                            (track-string currently-playing)))))
    (when choice
      (add-song-to-playlist (jsown:val currently-playing "uri") (cadadr choice))
      (message "^6~a^7 added to ^5~a^7." (jsown:val currently-playing "name") (car choice)))))
