
(defpackage lisp-journal
  (:use :cl :journal-package :entry-package))
(in-package :lisp-journal)


(defvar *journal-1*)
(setf *journal-1* (make-instance 'journal :owner "me"))

(defun add-entry-to-journal (title text)
  "Creates and adds a new entry to journal"
  (journal-package:add-entry *journal-1* (make-instance 'entry 
                                                      :title title 
                                                      :text text)))

(defun show-nth-entry (n)
  "Show the nth entry of journal"
  (let* ((journal-entry (nth n (journal-package:entries *journal-1*))))
    (list 
      (entry-package:date journal-entry) 
      (entry-package:title journal-entry) 
      (entry-package:text journal-entry) 
      (entry-package:bookmark journal-entry))))

(defun get-all-entries-journal ()
   "Get all the entries of journal"
   (journal-package:get-all-entries *journal-1*))

(defun search-for-entry-journal (text)
   "Get all the entries of journal"
   (journal-package:search-for-entry *journal-1* text))



(add-entry-to-journal "entry title 1" "entry text 1")
(show-nth-entry 0)
(add-entry-to-journal "entry title 2" "entry text 2")
(show-nth-entry 1)
(add-entry-to-journal "entry title 3" "entry text 3")


;;(get-all-entries-journal)
(search-for-entry-journal "entry title 1")

      

