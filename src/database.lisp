(defpackage database-package
  (:use :cl
        :entry-package 
        :journal-package)
  (:export :database
           :data
           :save-journal))
           
(in-package :database-package)

(defclass database ()
  ((filepath
     :initarg :filepath
     :initform (error "must supply filepath"))
   (data
     :initform ()))
  (:documentation "Persists journals and their entries to a file"))

(defmethod save-journal ((object database) journal)
  nil)
  
