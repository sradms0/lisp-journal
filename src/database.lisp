(defpackage database-package
  (:use :cl
        :local-time
        :entry-package 
        :journal-package)
  (:export :database
           :data
           :filepath
           :save-journal
           :load-journal))  
           
(in-package :database-package)

(defclass database ()
  ((filepath
     :initarg :filepath
     :initform (error "must supply filepath")
     :accessor filepath)
   (data
     :initform ()))
  (:documentation "Persists journals and their entries to a file"))

(defmethod save-journal ((object database) journal)
    (let ((entries-plist ()))
      (dolist (n-entry (entries journal))
        (push (list 
                :date (local-time:format-timestring nil (date n-entry)) 
                :title (title n-entry)  
                :text (text n-entry))
              entries-plist))
      (with-open-file (out (filepath object)
                           :direction :output
                           :if-exists :supersede)
       (with-standard-io-syntax
         (print entries-plist out)))))
  
(defmethod load-journal ((object database) journal)
  nil)
  
