(defpackage database-package
  (:use :cl
        :entry-package 
        :journal-package)
  (:export :database))
(in-package :database-package)

(defclass database ()
  ((filepath
     :initarg :filepath)
   (data
     :initform ()))
  (:documentation "Persists journals and their entries to a file"))


