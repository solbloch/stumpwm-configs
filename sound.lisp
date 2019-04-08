(in-package :stumpwm)

(ql:quickload :cl-ppcre)

(defun list-sinks ()
  (cl-ppcre:all-matches-as-strings "\\S*alsa_output\\S*"
                                   (run-shell-command "pactl list short sinks" t)))

(defun list-streams ()
  (mapcar
   #'(lambda (x) (cl-ppcre:split "\\s" x))
   (cl-ppcre:all-matches-as-strings "\\d*\\s*\\d*\\s*\\d*\\s[a-zA-Z\.\-]*\\s" (run-shell-command "pactl list short sink-inputs" t))))

(defun switch-sink (sink)
  (run-shell-command (concat "pacmd set-default-sink " sink))
  (loop for stream in (list-streams)
        do (run-shell-command
            (concat "pactl move-sink-input " (car stream) " " sink))))

(defcommand audio-switch () ()
  (let ((choice (select-from-menu (current-screen)
                                  (loop for sink in (list-sinks)
                                        collecting (list sink sink))
                                  nil 0 nil)))
    (if (null choice)
        nil
        (switch-sink (car choice)))))

(defun echo-volume ()
  (message (async-run "amixer sget Master | awk -F '[][]' '/^  Mono/ { print $2 }'")))

(defun echo-mute ()
  (if (search "yes" (async-run "pacmd list-sinks | awk '/muted/ {print $2}'"))
      (message "unmuted")
      (message "muted")))

(defcommand volume-up () ()
  (message (async-run "amixer set Master 5%+ | awk -F '[][]' '/^  Mono/ { print $2 }'")))

(defcommand volume-down () ()
  (message (async-run "amixer set Master 5%- | awk -F '[][]' '/^  Mono/ { print $2 }'")))

(defcommand volume-mute () ()
  (if (search "on" (async-run "pactl set-sink-mute 0 toggle && amixer get Master | awk -F '[][]' '/^  Mono/ {print $6}'"))
      (message "unmuted")
      (message "muted")))
