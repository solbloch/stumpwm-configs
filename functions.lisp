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

(defun percent (perc)
  (let ((on-string (make-string (floor (/ perc 5)) :initial-element #\▒)))
    (message "~a~a" on-string
             (make-string (- 20 (floor (/ perc 5))) :initial-element #\ ))))

;; (defcommand fix-audio () ()
;;   (run-shell-command "pacmd set-card-profile alsa_card.pci-0000_01_00.1 off"))

(defcommand sleep-pc () ()
  (turn-off-group *bedroom*)
  (run-shell-command "systemctl suspend"))

(defcommand float-keyboard-mouse () ()
  (let ((kb-mouse-list '("Synaptics TM3276-022"
                         "TPPS/2 IBM TrackPoint"
                         "ThinkPad Extra Buttons"
                         "AT Translated Set 2 keyboard")))
    (mapcar #'(lambda (x) (run-shell-command (str:concat "xinput float \'" x"\'"))) kb-mouse-list)))

(defcommand mpv-video0 () ()
  (run-shell-command "mpv /dev/video0 --profile=low-latency --untimed"))

(defcommand emoji-picker () ()
  (run-shell-command
   "cat ~/.stumpwm.d/emoji-list | dmenu -i -fn \"Apple Color Emoji:size=20\" -l 15 | awk '{print $1}' | xclip -r -sel clipboard"))

(defun mode-line-group-scroll (mode-line button x y)
  (declare (ignore mode-line x y))
  (case button
    (4 (gprev))
    (5 (gnext))
    (t nil)))

(defvar *magic-directories* '(#P"~/MOUNT/Downloads/Magic"))

(defvar *magic-files* '())

;; (defcommand refresh-magic-list () ()
;;   (let ((magic-files ()))
;;     (loop for dir in *magic-directories* do
;;       (cl-fad:walk-directory dir
;;         (lambda (name)
;;           (push name magic-files))
;;         :directories nil))
;;     (setf *magic-files* magic-files)))

(defcommand open-magic-file () ()
  (let ((choice (select-from-menu (current-screen)
    (loop for i in *magic-files*
          collecting
          (list (file-namestring i)
                (namestring i))) nil 0 nil)))
    (when choice
      (run-shell-command (str:concat "mpv \"" (cadr choice) "\"")))))

(defcommand melee () ()
  (setf (getenv "__GL_MaxFramesAllowed") "0")
  (uiop:launch-program "/home/sol/Downloads/FM-Slippi-2.3.0-beta.4-Linux.AppImage"))

(defcommand david-pakman-show () ()
  (let ((months '("january" "february" "march" "april" "may" "june"
                  "july" "august" "september" "october" "november" "december")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (declare (ignore second year))
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

(when *initializing*
  (add-hook *mode-line-click-hook* #'mode-line-group-scroll))
