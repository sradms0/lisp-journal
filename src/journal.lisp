(defpackage journal-package
  (:use :cl 
        :entry-package)
  (:export :journal
           :add-entry
           :remove-entry
           :entries))
(in-package :journal-package)
  
(defclass journal ()
  ((owner
     :initarg :owner
     :accessor owner)
   (entries
     :initform ()
     :accessor entries))
  (:documentation "Stores a collection of entries")) 

(defmethod add-entry ((object journal) entry)
  "Add a new entry to this journal"
    (setf (entries object) (append (entries object) (list entry))))

(defmethod remove-entry ((object journal) searched-title)
  "Remove an entry from this journal"
  (defun equal-title (n-entry)
    (equal searched-title (title n-entry)))
  (let ((found (find-if #'equal-title (entries object))))
    (cond (found (setf (entries object) (delete-if #'equal-title (entries object))) found)
          (t (error "Entry not found")))))
          
