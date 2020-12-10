(defpackage journal-package
  (:use :cl)
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

(defmethod remove-entry ((object journal) title)
  "Remove an entry from this journal"
  (first (entries object)))
  
  

