(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown))

(defvar *spotify-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") "copy-current-song-url")
    (define-key m (kbd "s") "search-track")
    (define-key m (kbd "p") "play-playlist")
    (define-key m (kbd "TAB") "echo-current-song")
    (define-key m (kbd "Right") "skip-forward")
    (define-key m (kbd "Left") "skip-backward")
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

(defvar scopes "user-read-playback-state user-read-recently-played user-read-currently-playing user-modify-playback-state playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private")

(defvar *spotify-oauth* (lispotify:make-spotify-oauth id secret redirect scopes nil))

(defmacro multi-val (item &rest vals)
  (if vals
      `(jsown:val (multi-val ,item ,@(butlast vals)) ,(car (last vals)))
      item))

(defun authorization-header ()
  `(("Authorization"
     . ,(str:concat "Bearer " (jsown:val (lispotify:token *spotify-oauth*) "access_token")))))

(defun get-playlists ()
  (let ((raw-results (lispotify:with-token *spotify-oauth*
                       (dex:get "https://api.spotify.com/v1/me/playlists?limit=50"
                                :headers (authorization-header)))))
    (loop for playlist in (jsown:val (jsown:parse raw-results) "items")
          collecting (list (format nil "~a [~a (~a)]"
                                   (jsown:val playlist "name")
                                   (multi-val playlist "owner" "display_name")
                                   (multi-val playlist "owner" "id"))
                           (jsown:val playlist "uri")
                           (jsown:val playlist "id")))))

(defun add-song-to-playlist (song-uri playlist-id)
  (lispotify:with-token *spotify-oauth*
    (dex:post (format nil "https://api.spotify.com/v1/playlists/~a/tracks" playlist-id)
              :headers (authorization-header)
              :content (jsown:to-json `(:obj ("uris" . (,song-uri)))))))

(defun get-current-song ()
  (lispotify:with-token *spotify-oauth*
    (let ((request (dex:get "https://api.spotify.com/v1/me/player/currently-playing"
                            :headers (authorization-header))))
      (when (not (emptyp request))
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
      (multi-val (jsown:parse raw-results) "tracks" "items"))))

;; Commands

(defcommand search-track (track) ((:string "track: "))
  (if (null track)
      (throw 'error "Abort.")
      (let* ((results (search-track-func track))
             (results-alist
               (loop for i in results
                     collecting
                     `(,(str:concat (jsown:val i "name") " - "
                                    (multi-val i "album" "name")
                                    " - "
                                    (format nil "~{~a~^ & ~}"
                                            (loop for artist in (jsown:val i "artists")
                                                  collecting (jsown:val artist "name"))))
                       (,(jsown:val i "uri") ,(multi-val i "album" "uri")
                        ,(multi-val i "external_urls" "spotify")))))
             (choice (select-from-menu (current-screen)
                                       results-alist nil 0 *spotify-menu-keymap*)))
        (when choice
          (play-song (caadr choice))))))

(defcommand play-playlist () ()
  (let* ((playlists (get-playlists))
         (choice (select-from-menu (current-screen) playlists nil 0 nil)))
    (when choice
      (play-context-uri (second choice)))))

(defcommand echo-current-song () ()
  (let* ((current-song-data (get-current-song))
         (item-data (when (not (emptyp current-song-data))
                      (jsown:val current-song-data "item"))))
    (if item-data
        (message "Listening to ^6~a - ~a^7."
                 (jsown:val item-data "name")
                 (multi-val item-data "album" "name"))
        (message "Nothing playing."))))

(defcommand copy-current-song-url () ()
  (let* ((current-song-data (get-current-song))
         (item-data (when (not (emptyp current-song-data))
                      (jsown:val current-song-data "item"))))
    (if item-data
        (progn (set-x-selection
                (cdadr (jsown:val item-data "external_urls")) :clipboard)
               (message "Link to ^6~a - ~a^7 copied."
                        (jsown:val item-data "name")
                        (multi-val item-data "album" "name")))
        (message "Nothing playing."))))

(defcommand skip-forward () ()
  (lispotify:with-token *spotify-oauth*
    (dex:post "https://api.spotify.com/v1/me/player/next"
              :headers (authorization-header))))

(defcommand skip-backward () ()
  (lispotify:with-token *spotify-oauth*
    (dex:post "https://api.spotify.com/v1/me/player/previous"
              :headers (authorization-header))))

(defcommand add-current-song-playlist () ()
  (let* ((current-song-data (get-current-song))
         (item-data (jsown:val current-song-data "item"))
         (playlists (get-playlists))
         (choice (select-from-menu (current-screen) playlists
                                   (format nil "Add to ^6~a - ~a^7 to which playlist?"
                                           (jsown:val item-data "name")
                                           (multi-val item-data "album" "name")))))
    (when choice
      (add-song-to-playlist (jsown:val item-data "uri") (car (last choice)))
      (message "~a added to ~a" (jsown:val item-data "name") (car choice)))))
