(in-package :stumpwm)

(defvar *network-file* "/sys/class/net/eno1/carrier")

(setf stumpwm:*screen-mode-line-format*
      (list
       "%g^> | %l | "
       '(:eval (battery-string))
       " | "
       '(:eval (cpu-temp))
       "° | "
       '(:eval (time?))))

;; "    "
;; '(:eval (network-state))))

;; (set-font (make-instance 'xft:font :family "WenQuanYi Micro Hei" :subfamily "Regular" :size 16))
;; (set-font (make-instance 'xft:font :family "NanumGothicCoding"
;;                                     :subfamily "Regular"
;;                                     :size 16))
;; (set-font (list
;;            (make-instance 'xft:font :family "Source Han Sans SC Light"
;;                                     :subfamily "Regular"
;;                                     :size 13)
;;            "-xos4-terminus-medium-r-bold--20-200-72-72-c-100-iso10646-1"))

(set-font "-xos4-terminus-bold-r-normal--24-240-72-72-c-120-iso10646-1")



(run-with-timer
 900 900
 (lambda ()
   (loop for font in (stumpwm::screen-fonts (current-screen))
         when (typep font 'xft:font)
           do (clrhash (xft::font-string-line-bboxes font))
              (clrhash (xft::font-string-line-alpha-maps font))
              (clrhash (xft::font-string-bboxes font))
              (clrhash (xft::font-string-alpha-maps font)))))

;; azrin
;; (define-frame-preference "q-tip"
;;   (0 t t :class "Emacs"))

;; (define-frame-preference "jarobi"
;;   (0 t t :class "Spotify")
;;   (1 t t :class "Ripcord"))
