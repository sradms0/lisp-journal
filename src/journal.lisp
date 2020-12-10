(defpackage journal-package
  (:use :cl 
        :entry-package)
  (:export :journal
           :entries
           :add-entry
           :get-all-entries
           :search-for-entry
           :remove-entry))
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

(defmethod get-all-entries ((object journal))
  "Get all the entries"
   (return-from get-all-entries (entries object)))

(defmethod search-for-entry ((object journal) text)
  "Search for an entry in the journal"
  (loop for x from 0 to  (- (list-length (entries object)) 1))
  if(string= (let* ((journal-entry (nth x (entries object)))) (journal-entry title)) text)
  do(return-from search-for-entry (journal-entry)))

(defmethod remove-entry ((object journal) searched-title)
  "Remove an entry from this journal"
  (defun equal-title (n-entry)
    (equal searched-title (title n-entry)))
  (let ((found (find-if #'equal-title (entries object))))
    (cond (found (setf (entries object) (delete-if #'equal-title (entries object))) found)
          (t (error "Entry not found")))))

