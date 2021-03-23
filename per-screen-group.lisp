(in-package :stumpwm)

(defvar *metagroup* (group-by-name "meta"))

;; (defun pull-from-group-head (new-group frame head)
;;   (let (( ))))


(defun list-heads ()
  (screen-heads (current-screen)))

(defun swap-tile-group-frame-tree (g1 g2)
  (let ((g1-tree (tile-group-frame-tree g1))
        (g2-tree (tile-group-frame-tree g2)))
    (setf (tile-group-frame-tree g1) g2-tree)
    (setf (tile-group-frame-tree g2) g1-tree)))

(defun swap-tile-group-head-windows (g1 g2 head)
  (let ((g1-windows (head-windows g1 head))
        (g2-windows (head-windows g2 head)))
    (move-windows-to-group g1-windows g2)
    (move-windows-to-group g2-windows g1)))

(defun swap-tree-group-head (g1 g2 head)
  (let ((g1-tree (if (<= (length (head-frames g1 head)) 1)
                     (car (head-frames g1 head))
                     (head-frames g1 head)))
        (g2-tree (if (<= (length (head-frames g2 head)) 1)
                     (car (head-frames g2 head))
                     (head-frames g2 head))))
    (nsubstitute-if g2-tree #'(lambda (x) (equal x g1-tree)) (tile-group-frame-tree g1))
    (nsubstitute-if g1-tree #'(lambda (x) (equal x g2-tree)) (tile-group-frame-tree g2))))

(defun swap-windows-and-frame-tree (g1 g2 head)
  (swap-tree-group-head g1 g2 head)
  (swap-tile-group-head-windows g1 g2 head))


;; (setf (tile-group-frame-tree (group-by-name "4")) (tile-group-frame-tree (group-by-name "2")))
;; (setf (tile-group-frame-tree (group-by-name "2")) (tile-group-frame-tree (group-by-name "4")))
