(defpackage journal-package
  (:use :cl 
        :entry-package)
  (:export :journal
           :entries
           :owner
           :add-entry
           :get-all-entries
           :search-for-entry
           :remove-entry
           :get-all-bookmarked-entries))
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
  (cond ((not entry) (error "entry is has no data (nil)"))
        (t (setf (entries object) (append (entries object) (list entry))))))

(defmethod get-all-entries ((object journal))
  "Get all the entries"
   (return-from get-all-entries (entries object)))

(defmethod search-for-entry ((object journal) text)
  (let ((found (find-if #'(lambda (n-entry) (equal text (title n-entry))) (entries object))))
    (cond (found found)
          (t (error "Entry not found")))))

(defmethod remove-entry ((object journal) searched-title)
  "Remove an entry from this journal"
  (defun equal-title (n-entry)
    (equal searched-title (title n-entry)))
  (let ((found (find-if #'equal-title (entries object))))
    (cond (found (setf (entries object) (delete-if #'equal-title (entries object))) found)
          (t (error "Entry not found")))))

(defmethod get-all-bookmarked-entries ((object journal))
  "Get all entries with bookmarks"
    (let ((found ()))
      (dolist (n-entry (entries object))
        (if (bookmark n-entry) (setf found (cons n-entry found))))
      (cond (found found)
            (t (error "No bookmarked entries found")))))
            
      
