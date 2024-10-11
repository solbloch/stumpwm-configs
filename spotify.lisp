(in-package :stumpwm)

(load "/home/sol/Projects/lispotify/lispotify.asd")

(ql:quickload '(:lispotify :jsown :jonathan))

(use-package :lispotify)

(defvar *spotify-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") "copy-current-song-url")
    (define-key m (kbd "s") "search-track")
    (define-key m (kbd "S") "search-track-queue")
    (define-key m (kbd "p") "play-playlist")
    (define-key m (kbd "a") "add-current-song-playlist")
    (define-key m (kbd "TAB") "echo-current-song")
    (define-key m (kbd "Right") "skip-forward")
    (define-key m (kbd "Left") "skip-backward")
    (define-key m (kbd "d") "play-on-device")
    m))

(defvar *spotify-menu-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c") 'copy-url)
    (define-key m (kbd "C-a") 'add-song-to-playlist-menu)
    m))

(define-key *top-map* (kbd "s-m") *spotify-keymap*)

(defun copy-url (menu)
  (set-x-selection (third (second (nth (menu-selected menu) (menu-table menu)))) :clipboard)
  (throw :menu-quit nil)
  (message "Copied."))

(defun add-song-to-playlist-menu (menu)
  (let ((song-name (car (nth (menu-selected menu) (menu-table menu))))
        (song-uri (caadr (nth (menu-selected menu) (menu-table menu)))))
    (add-song-to-playlist-prompt song-name song-uri)
    (throw :menu-quit nil)))

(defvar scopes "user-read-playback-state user-read-recently-played user-read-currently-playing user-modify-playback-state playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private")

(defvar *spotify-oauth* (make-spotify-oauth id secret redirect scopes nil))

(defmacro multi-val (object &rest vals)
  (if vals
      `(jsown:val (multi-val ,object ,@(butlast vals)) ,(car (last vals)))
      object))

(defun get-playlists ()
  (let ((raw-results (spotify-api-request *spotify-oauth* "me/playlists?limit=50")))
    (loop for playlist in (jsown:val (jsown:parse raw-results) "items")
          collecting (list (format nil "^5~a^7 [~a (~a)]"
                                   (jsown:val playlist "name")
                                   (multi-val playlist "owner" "display_name")
                                   (multi-val playlist "owner" "id"))
                           (list (jsown:val playlist "uri") (jsown:val playlist "id")
                                 (multi-val playlist "external_urls" "spotify"))))))

(defun add-song-to-playlist (song-uri playlist-id)
  (spotify-api-request *spotify-oauth* (format nil "playlists/~a/tracks" playlist-id)
                       :method :post
                       :content (jsown:to-json `(:obj ("uris" . (,song-uri))))))

(defun get-currently-playing ()
  (let ((request (spotify-api-request *spotify-oauth* "me/player/currently-playing")))
    (if (emptyp request)
        (throw 'error "Nothing playing.")
        (jsown:parse request))))

(defun play-context-uri (context-uri)
  (spotify-api-request *spotify-oauth* "me/player/play"
                       :method :put
                       :content (jsown:to-json `(:obj ("context_uri". ,context-uri)))))

(defun play-song (context-uri track-num &optional (device-id nil))
  (spotify-api-request *spotify-oauth* "me/player/play"
                                 :headers (when device-id `(("device_id" . ,device-id)))
                                 :content (jsown:to-json `(:obj ("context_uri". ,context-uri)
                                                                ("offset". (:obj ("position". ,(- track-num 1))))))
                                 :method :put))

(defun queue-song (track-uri &optional (device-id nil))
  (spotify-api-request *spotify-oauth* (format nil "me/player/queue/?uri=~a" track-uri)
                       :headers (when device-id `(("device_id" . ,device-id)))
                       :method :post))

(defun play-play (device-id)
  (spotify-api-request *spotify-oauth* "me/player"
                       :method :put
                       :content (jsown:to-json `(:obj ("device_ids" . (,device-id))))))

(defun get-devices ()
  (spotify-api-request *spotify-oauth* "me/player/devices"))

(defun search-track-func (name)
  "search a string and return a list of tracks in jsown object format"
  (let ((raw-results (handler-case
                         (spotify-api-request *spotify-oauth*
                                              (str:concat "search?q="
                                                          (quri:url-encode name)
                                                          "&type=track"))
                       (dex:http-request-failed (e)
                         (format nil "~a" e)))))
    (multi-val (jsown:parse raw-results) "tracks" "items")))

(defun track-string (song-item)
  (format nil "~a^7 -^5 ~a^7 -^2 ~{~a~^, ~}^7"
          (jsown:val song-item "name")
          (multi-val song-item "album" "name")
          (loop for artist in (jsown:val song-item "artists")
                collecting (jsown:val artist "name"))))

(defun add-song-to-playlist-prompt (song-name song-uri)
  (let* ((playlists (get-playlists))
         (choice (select-from-menu (current-screen) playlists
                                   (format nil "Add to ^6~a^7 to which playlist?"
                                           song-name))))
    (when choice
      (add-song-to-playlist song-uri (cadadr choice))
      (message "^6~a^7 added to ^5~a^7." song-name (car choice)))))

;; Commands
(defcommand search-track (track) ((:string "Track: "))
  (when track
    (let* ((results (search-track-func track))
           (results-alist
             (loop for i in results
                   collecting
                   (list (track-string i)
                         (list (jsown:val i "uri") (multi-val i "album" "uri")
                               (multi-val i "external_urls" "spotify")
                               (jsown:val i "track_number")))))
           (choice (select-from-menu (current-screen) results-alist nil 0
                                     *spotify-menu-keymap*)))
      (when choice
        (play-song (cadadr choice) (cadr (cddadr choice)))))))

(defcommand search-track-queue (track) ((:string "Track: "))
  (when track
    (let* ((results (search-track-func track))
           (results-alist
             (loop for i in results
                   collecting
                   (list (track-string i)
                         (list (jsown:val i "uri") (multi-val i "album" "uri")
                               (multi-val i "external_urls" "spotify")
                               (jsown:val i "track_number")))))
           (choice (select-from-menu (current-screen) results-alist nil 0
                                     *spotify-menu-keymap*)))
      (when choice
        (queue-song (caadr choice))))))

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
  (spotify-api-request *spotify-oauth* "me/player/next" :method :post))

(defcommand skip-backward () ()
  (spotify-api-request *spotify-oauth* "me/player/previous" :method :post))

(defcommand add-current-song-playlist () ()
  (let ((currently-playing (jsown:val (get-currently-playing) "item")))
    (add-song-to-playlist-prompt (track-string currently-playing)
                                 (jsown:val currently-playing "uri"))))

(defcommand play-on-device () ()
  (let* ((device-list-raw (jsown:parse (get-devices)))
         (devices (jsown:val device-list-raw "devices"))
         (device-table (mapcar #'(lambda (device)
                                   (list (jsown:val device "name")
                                         (jsown:val device "id")))
                               devices))
         (choice (select-from-menu (current-screen) device-table
                                   "Play on which device?")))
    (when choice
      (play-play (cadr choice)))))
