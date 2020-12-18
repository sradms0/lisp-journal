(defpackage userInterface-package
  (:use 
    :cl 
    :database-package 
    :journal-package 
    :entry-package)
  (:export 
    :protected-main))
(in-package :userInterface-package)

(defvar *journal-1*)
;;(setf *journal-1* nil)

(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))


;Needs a top layer 
;asks user what function to run
;runs selected function


(defun create-journal(journalName)
  (setf *journal-1* (make-instance 'journal :owner journalName))
    (concatenate 'string (owner *journal-1*) " created")
)


(defun add-entry-to-journal (title text)
  "Creates and adds a new entry to journal"
  (journal-package:add-entry *journal-1* (make-instance 'entry 
                                                      :title title 
                                                      :text text)))
                                                     
(defun  add-entry-user-input()
  (add-entry-to-journal
    (prompt-read "Enter Title")
    (prompt-read "Enter text"))
    (print "Added")
    )

(defun search-for-entry-user-input()
   (entry-contents (search-for-entry *journal-1* (prompt-read "Enter Title to find")))
)

(defun entry-search-user-input()
  (search-for-entry *journal-1* (prompt-read "Enter Title to find"))
)

(defun remove-entry-user-input()
  (remove-entry
    *journal-1* (prompt-read "Enter Title to remove"))
    (print "Removed Entry")
    )    

(defun get-all-entries-user-input()
    (entry-contents-loop(get-all-entries *journal-1*)))

(defun get-all-bookmarked--entries-user-input()
    (entry-contents-loop(get-all-bookmarked-entries *journal-1*)))

(defun edit-title-of-entry-user-input()
    (edit-title (entry-search-user-input) (prompt-read "Enter new title"))
    (print "Edited title")
)
(defun edit-text-of-entry-user-input()
    (edit-text (entry-search-user-input) (prompt-read "Enter new text"))
    (print "Edited text")
)

(defun add-bookmark-to-entry()
  (add-bookmark (search-for-entry *journal-1* (prompt-read "Enter Title to find")))
  (print "Bookmark added")
)

(defun remove-bookmark-from-entry()
  (remove-bookmark (search-for-entry *journal-1* (prompt-read "Enter Title to find")))
  (print "Bookmark removed")
)

(defun entry-contents-loop(entries)
 (let ((found ()))
  (dolist (n-entry entries)
       (setf found (cons (entry-contents n-entry) found))) found)
)

(defun entry-contents(entryIn)
   (list 
      (entry-package:date entryIn) 
      (entry-package:title entryIn) 
      (entry-package:text entryIn) 
      (entry-package:bookmark entryIn)))
      



(defun create-database()
  (defvar *db*
   (setf *db* (make-database))))


(defun save-user-journal()
  (save-journal *db*  *journal-1*)
)

(defun load-user-journal()
  (setf *journal-1* (make-instance 
    'journal :owner (prompt-read "Enter the name to load the journal")))
    (load-journal *db* *journal-1*)
    (print "loaded")
)


  
(defun prompt-user ()
    (let ((user-input ""))
    
    (setf user-input (prompt-read "Do you want to  load journal[0] create journal[1]
    add entry[2], searchForEntry[3], 
    remove entry[4], get all entries[5], 
    get all bookedmared entries[6], edit title of entry[7], edit text of entry[8], 
    add book mark to entry[9], or remove bookmark[10], go to main[11] "))
       
        (cond
            ((= (parse-integer user-input) 0 ) (protect-prompt #'load-user-journal))
            ((= (parse-integer user-input) 1 ) (protect-prompt #'create-new-journal))
            ((= (parse-integer user-input) 2 ) (protect-prompt #'add-entry-user-input))
            ((= (parse-integer user-input) 3 ) (print(protect-prompt #'search-for-entry-user-input)))
            ((= (parse-integer user-input) 4 ) (protect-prompt #'remove-entry-user-input))
            ((= (parse-integer user-input) 5 ) (print(protect-prompt #'get-all-entries-user-input)))
            ((= (parse-integer user-input) 6 ) (print(protect-prompt #'get-all-bookmarked--entries-user-input)))
            ((= (parse-integer user-input) 7 ) (protect-prompt #'edit-title-of-entry-user-input))
            ((= (parse-integer user-input) 8 ) (protect-prompt #'edit-text-of-entry-user-input))
            ((= (parse-integer user-input) 9 ) (protect-prompt #'add-bookmark-to-entry))
            ((= (parse-integer user-input) 10 ) (protect-prompt #'remove-bookmark-from-entry))
            ((= (parse-integer user-input) 11 ) (protect-prompt #'main))

        )(save-user-journal)
        )
  
)

(defun protect-prompt(method)
 (handler-case (funcall method)
  (t (c)
    (format t "Got an exception: ~a~%" c)
    (values  c)
    (progn
      (prompt-user))))
)

;;Catches errors
(defun protect(method)
 (handler-case (funcall method)
  (t (c)
    (format t "Got an exception: ~a~%" c)
    (values  c)
    (progn
      (protect method))))
)

(defun protected-main()
  (protect #'main)
)

(defun create-new-journal()
  (create-journal (prompt-read "Enter name of new journal"))
  (save-user-journal)
  (load-journal *db* *journal-1*)
)
    

(defun main()
  (create-database)
  
  (setf *journal-1* nil)
  (loop while(is-empty *db*)
        do (create-new-journal))
  
  
  (if (not *journal-1*)
    (load-user-journal))
  
  
  (loop (prompt-user)
      (if (not (y-or-n-p "Do you want to do something else? [y/n]: ")) (return))))
