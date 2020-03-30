(in-package :stumpwm)

(defun get-active-sink ()
  (str:trim (run-shell-command "pactl list short sinks | awk '/RUNNING/{print $1}'" t)))

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
    (when choice
      (switch-sink (car choice)))))

(defun get-volume ()
  (parse-integer (run-shell-command "pamixer --get-volume-human" t) :junk-allowed t))

(defun get-volume-string ()
  (str:trim (run-shell-command "pamixer --get-volume-human" t)))

(defun echo-volume ()
  (let ((vol (get-volume)))
    (if vol
        (percent vol)
        (message "Muted"))))

(defcommand volume-up () ()
  (run-shell-command "pamixer -i 5" t)
  (echo-volume)
  (bt:make-thread (lambda () (update-mode-line-process))))

(defcommand volume-down () ()
  (run-shell-command "pamixer -d 5" t)
  (echo-volume)
  (bt:make-thread (lambda () (update-mode-line-process))))

(defcommand volume-mute () ()
  (run-shell-command "pamixer -t")
  (echo-volume)
  (bt:make-thread (lambda () (update-mode-line-process))))

;; (run-shell-command "pactl set-sink-mute $(pactl list short sinks | awk '/RUNNING|IDLE/{print $1}') toggle" t)
