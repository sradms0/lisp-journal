
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




(defun show-all-entry ()
   "Show all the entries of journal"
  (loop for x from 0 to  (- (list-length (journal-package:entries *journal-1*)) 1)
  do (print(show-nth-entry x)))
)

(defun search-for-entry (text)
  "Search for an entry in the journal"
  
  (loop for x from 0 to  (- (list-length (journal-package:entries *journal-1*)) 1)
  if(string= (let* ((journal-entry (nth x (journal-package:entries *journal-1*)))) (entry-package:title journal-entry)) text)
  do(print(show-nth-entry x))
)
)


(add-entry-to-journal "entry title 1" "entry text 1")
(show-nth-entry 0)
(add-entry-to-journal "entry title 2" "entry text 2")
(show-nth-entry 1)
(add-entry-to-journal "entry title 3" "entry text 3")

(show-all-entry)
(search-for-entry "entry title 1")


;; Length of the journal list 
;; (print (list-length (journal-package:entries *journal-1*)))

;;Displays first entry only the title
;;(print(let* ((journal-entry (nth 0 (journal-package:entries *journal-1*)))) (entry-package:title journal-entry)))

;;Comparing the first entry in the journal to a string
;;(print(string= (let* ((journal-entry (nth 0 (journal-package:entries *journal-1*)))) (entry-package:title journal-entry)) "entry title 1"))
      

