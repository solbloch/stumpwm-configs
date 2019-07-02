(in-package :stumpwm)

(ql:quickload :cl-ppcre)

(defun list-sinks ()
  (cl-ppcre:all-matches-as-strings "\\S*alsa_output\\S*"
                                   (run-shell-command "pactl list short sinks" t)))

(defun list-streams ()
  (mapcar
   #'(lambda (x) (cl-ppcre:split "\\s" x))
   (cl-ppcre:all-matches-as-strings "\\d*\\s*\\d*\\s*\\d*\\s[a-zA-Z\.\-]*\\s"
                                    (run-shell-command "pactl list short sink-inputs" t))))

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

(defun get-volume ()
  (run-shell-command "pactl list sinks | awk -v sink=$(pactl list short sinks | awk '/RUNNING|IDLE/{print $1}') '/^[[:space:]]Volume:/{i++}i==sink{print $5; exit}'" t))

(defun echo-volume ()
  (message (get-volume)))

(defun echo-mute ()
  (if (search "no" (run-shell-command "pacmd list-sinks | awk -v sink=$(pactl list short sinks | awk '/RUNNING|IDLE/{print $1}') '/muted/{i++}i==sink{print; exit}'" t))
      (message "unmuted")
      (message "muted")))

(defcommand volume-up () ()
  (run-shell-command "pactl set-sink-volume $(pactl list short sinks | awk '/RUNNING|IDLE/{print $1}') +5%" t)
  (let ((volume (get-volume)))
    (percent (parse-integer (subseq volume 0 (- (length volume) 2))))))

(defcommand volume-down () ()
  (run-shell-command "pactl set-sink-volume $(pactl list short sinks | awk '/RUNNING|IDLE/{print $1}') -5%" t)
  (let ((volume (get-volume)))
    (percent (parse-integer (subseq volume 0 (- (length volume) 2))))))

(defcommand volume-mute () ()
  (run-shell-command "pactl set-sink-mute $(pactl list short sinks | awk '/RUNNING|IDLE/{print $1}') toggle" t)
  (echo-mute))
