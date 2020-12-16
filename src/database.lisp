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
                :text (text n-entry)
                :bookmark (bookmark n-entry)) 
              entries-plist))
      (with-open-file (out (filepath object)
                           :direction :output
                           :if-exists :supersede)
       (with-standard-io-syntax
         (print entries-plist out)))))
  
(defmethod load-journal ((object database) journal)
  (cond ((not (probe-file (filepath object))) 
         (error (concatenate 'string (filepath object) "journal file does not exist")))
        (t
            (with-open-file (in (filepath object))
               (with-standard-io-syntax 
                 (dolist (props (read in))
                   (add-entry journal 
                      (make-instance 'entry 
                            :date (local-time:parse-timestring (getf props :date))
                            :title (getf props :title) 
                            :text (getf props :text)
                            :bookmark (getf props :bookmark)))))))))  

