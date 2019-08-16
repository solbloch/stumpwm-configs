(defun load-next ()
  (asdf:load-asd "/home/sol/Projects/next/next.asd")
  (ql:quickload :next))
