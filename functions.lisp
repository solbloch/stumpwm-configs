(in-package :stumpwm)

(defcommand killandremove () ()
  (stumpwm:run-commands
   "delete-window"
   "remove-split"))

(defcommand redshift-temp (temp) ((:number "temp?? : "))
  (run-shell-command (str:concat "redshift -O " (write-to-string temp))))

(defcommand all-windowlist (&optional (fmt *window-format*)
                            window-list) (:rest)
  (let ((window-list (or window-list
                         (sort-windows-by-number
                          (screen-windows (current-screen))))))
    (if (null window-list)
        (message "No Managed Windows")
        (let ((window (select-window-from-menu window-list fmt)))
          (if window
              (progn
                (switch-to-group (window-group window))
                (group-focus-window (window-group window) window))
              (throw 'error :abort))))))

(defcommand all-windowlist-formatted () ()
  (all-windowlist "%s%300t"))

(defcommand ripcord () ()
  (run-or-raise "ripcord" '(:class "Ripcord")))

(defcommand darktable () ()
  (run-or-raise "darktable" '(:class "Darktable")))

(defcommand telegram () ()
  (run-or-raise "telegram-desktop" '(:class "Telegram")))


(defcommand emacs-fixed () ()
  (run-shell-command "emacsclient -c"))

(defcommand spotify () ()
  (run-or-raise "spotify" '(:class "Spotify")))

(defcommand teams () ()
  (run-or-raise "teams" '(:class "Teams")))

(defun percent (perc)
  (let ((on-string (make-string (floor (/ perc 5)) :initial-element #\▒)))
    (message "~a~a" on-string
             (make-string (- 20 (floor (/ perc 5))) :initial-element #\ ))))

;; (defcommand fix-audio () ()
;;   (run-shell-command "pacmd set-card-profile alsa_card.pci-0000_01_00.1 off"))

(defcommand float-keyboard-mouse () ()
  (let ((kb-mouse-list '("Synaptics TM3276-022"
                         "TPPS/2 IBM TrackPoint"
                         "ThinkPad Extra Buttons"
                         "AT Translated Set 2 keyboard")))
    (mapcar #'(lambda (x) (run-shell-command (str:concat "xinput float \'" x"\'"))) kb-mouse-list)))

(defcommand mpv-video0 () ()
  (run-shell-command "mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:/dev/video0"))

(defcommand emoji-picker () ()
  (run-shell-command
   "cat ~/.stumpwm.d/emoji-list | dmenu -i -fn \"Noto Color Emoji:size=20\" -l 15 | awk '{print $1}' | xclip -r -sel clipboard"))

(defvar *magic-directories* '(#P"~/MOUNT/Downloads/Magic"))

(defvar *magic-files* '())

(defcommand refresh-magic-list () ()
  (let ((special-magic-dir *magic-files*)
        (b *standard-output*))
    (bt:make-thread
     (lambda ()
       (let ((magic-files ()))
         (loop for dir in *magic-directories* do
           (cl-fad:walk-directory dir
                                  (lambda (name)
                                    (push name magic-files))
                                  :directories nil))
         (setq *magic-files* magic-files)
         (format b "~a" magic-files))))))

(defcommand magic-file () ()
  (let ((choice (select-from-menu (current-screen)
    (loop for i in *magic-files*
          collecting
          (list (file-namestring i)
                (namestring i))) nil 0 nil)))
    (when choice
      (run-shell-command (str:concat "mpv \"" (cadr choice) "\"")))))

(defcommand melee () ()
  (setf (getenv "__GL_MaxFramesAllowed") "0")
  (uiop:launch-program "/home/sol/.config/Slippi\\ Launcher/netplay/Slippi_Online-x86_64.AppImage"))

(defcommand david-pakman-show () ()
  (let ((months '("january" "february" "march" "april" "may" "june"
                  "july" "august" "september" "october" "november" "december")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (declare (ignorable second minute hour))
      (if (> day-of-week 4)
          (setf date (- date (- day-of-week 4))))
      (run-shell-command (format nil "xdg-open https://davidpakman.com/~a/~2,'0d/~a-~a-~a"
                                 year month (nth (1- month) months) date year)))))

(defcommand always-show () ()
  (if (typep (current-window) 'float-window)
      (progn (unfloat-window (current-window) (current-group))))
  (toggle-always-show)
  (toggle-always-on-top))

(defun group-by-name (name)
  (find-if #'(lambda (x)
               (equal name (group-name x)))
           (sort-groups (current-screen))))


(defun mode-line-group-scroll (mode-line button x y)
  (declare (ignore mode-line x y))
  (case button
    (4 (gprev))
    (5 (gnext))
    (t nil)))

(defun mode-line-window-cycle-click (mode-line button x y)
  (declare (ignore mode-line x y))
  (case button
    (1 (pull-hidden-next))
    (3 (pull-hidden-previous))
    (t nil)))

(defun mode-line-keyboard-toggle (mode-line button x y)
  (declare (ignore mode-line x y))
  (case button
    (2 (keyboard-toggle))
    (t nil)))

(defcommand deal () ()
    (let* ((players (+ 2 (random 6)))
           (position (1+ (random players))))
      (message "players: ~a position: ~a" players position)))

(defun keyboard-enabled-p ()
  (let ((output (run-shell-command
                 "xinput list-props 'AT Translated Set 2 keyboard' | grep 'Device Enabled' |  grep -o '[01]$'"
                 t)))
    (if (eq 1 (parse-integer output)) t)))

(defcommand keyboard-toggle () ()
  (if (keyboard-enabled-p)
      (run-shell-command "xinput disable 'AT Translated Set 2 keyboard'")
      (progn
        (run-shell-command "xinput enable 'AT Translated Set 2 keyboard'" t)
    (run-shell-command "xcape -e 'Control_L=Escape'" t))))

(when *initializing*
  (progn
    (add-hook *mode-line-click-hook* #'mode-line-group-scroll)
    (add-hook *mode-line-click-hook* #'mode-line-window-cycle-click)
    (add-hook *mode-line-click-hook* #'mode-line-keyboard-toggle)))
