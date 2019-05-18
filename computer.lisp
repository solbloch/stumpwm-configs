(in-package :stumpwm)

(defvar *network-file* "/sys/class/net/wlp58s0/carrier")

;; (mapc (lambda (x) (format t "Family: ~a  Subfamilies: ~{~a, ~}~%" x (clx-truetype:get-font-subfamilies x)) ) (clx-truetype:get-font-families))

(set-font (make-instance 'xft:font :family "TerminessTTF Nerd Font" :subfamily "Medium" :size 27))
;; (set-font "-xos4-terminus-medium-r-normal--32-320-72-72-c-160-iso10646-1")
;; (set-font "-gnu-unifont-medium-r-normal-sans-16-160-75-75-c-80-iso10646-1")


;; (font-exists-p  "-xos4-terminus-medium-r-normal--32-320-72-72-c-160-iso10646-1")

(run-with-timer
 900 900
 (lambda ()
   (loop for font in (stumpwm::screen-fonts (current-screen))
         when (typep font 'xft:font)
           do (clrhash (xft::font-string-line-bboxes font))
              (clrhash (xft::font-string-line-alpha-maps font))
              (clrhash (xft::font-string-bboxes font))
              (clrhash (xft::font-string-alpha-maps font)))))
