(defpackage userInterface
  (:use :cl :journal-package :entry-package))
(in-package :userInterface)


(defvar *journal-1*)
(setf *journal-1* (make-instance 'journal :owner "me"))

(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))


;Needs a top layer 
;asks user what function to run
;runs selected function

(defun add-entry-to-journal (title text)
  "Creates and adds a new entry to journal"
  (journal-package:add-entry *journal-1* (make-instance 'entry 
                                                      :title title 
                                                      :text text)))

(defun  add-entry-user-input()
  (add-entry-to-journal
    (prompt-read "Enter Title")
    (prompt-read "Enter text")))

(defun search-for-entry-user-input()
  (search-for-entry
    (prompt-read "Enter Title to find")))

(defun remove-entry-user-input()
  (remove-entry
    (prompt-read "Enter Title to remove")))    



  
(defun show-nth-entry (n)
  "Show the nth entry of journal"
  (let* ((journal-entry (nth n (journal-package:entries *journal-1*))))
    (list 
      (entry-package:date journal-entry) 
      (entry-package:title journal-entry) 
      (entry-package:text journal-entry) 
      (entry-package:bookmark journal-entry))))  
  
                                                   

(add-entry-user-input)
(print(show-nth-entry 0))