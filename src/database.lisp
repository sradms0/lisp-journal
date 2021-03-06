(defpackage database-package
  (:use :cl
        :local-time
        :entry-package 
        :journal-package)
  (:export :make-database
           :data
           :filepath
           :is-empty
           :get-journal-listing
           :save-journal
           :load-journal))  
           
(in-package :database-package)

(defclass database ()
  ((filepath
     :initform "./journal-storage/"
     :accessor filepath)
   (data
     :initform ()))
  (:documentation "Persists journals and their entries to a file"))

(defun make-database ()
  (ensure-storage-exists)
  (make-instance 'database))

(defun ensure-storage-exists ()
  (ensure-directories-exist "./journal-storage/"))

(defmethod get-journal-listing ((object database))
  (let ((journal-listing ()))
    (dolist (file-path (uiop:directory-files "./journal-storage/"))
      (setf journal-listing (append journal-listing (list (pathname-name file-path)))))
    (cond ((not journal-listing) (list "There are no journals in storage"))
          (t journal-listing))))

(defmethod is-empty ((object database))
  (ensure-storage-exists)
  (not (uiop:directory-files "./journal-storage/"))) 

(defmethod save-journal ((object database) journal)
    (ensure-storage-exists)
    (let ((entries-plist ()))
      (dolist (n-entry (entries journal))
        (push (list 
                :date (local-time:format-timestring nil (date n-entry)) 
                :title (title n-entry)  
                :text (text n-entry)
                :bookmark (bookmark n-entry)) 
              entries-plist))
      (with-open-file (out (concatenate 'string (filepath object) (owner journal) ".ldb")
                           :direction :output
                           :if-exists :supersede)
       (with-standard-io-syntax
         (print entries-plist out)))))
  
(defmethod load-journal ((object database) journal)
  (ensure-storage-exists)
  (let ((journal-filepath (concatenate 'string (filepath object) (owner journal) ".ldb")))
      (cond ((not (probe-file journal-filepath)) 
             (error (concatenate 'string journal-filepath " does not exist")))
            (t
                (with-open-file (in journal-filepath)
                   (with-standard-io-syntax 
                     (dolist (props (read in))
                       (add-entry journal 
                          (make-instance 'entry 
                                :date (local-time:parse-timestring (getf props :date))
                                :title (getf props :title) 
                                :text (getf props :text)
                                :bookmark (getf props :bookmark))))))))))
