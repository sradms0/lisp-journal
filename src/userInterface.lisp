(defpackage userInterface
  (:use 
    :cl 
    :database-package 
    :journal-package 
    :entry-package))
(in-package :userInterface)

(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))


;Needs a top layer 
;asks user what function to run
;runs selected function

(defun create-journal(journalName)
  (defvar *journal-1*)
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
   (entry-contents (search-for-entry *journal-1* (prompt-read "Enter Title to find"))))

(defun remove-entry-user-input()
  (remove-entry
    *journal-1* (prompt-read "Enter Title to remove")))    

(defun get-all-entries-user-input()
    (entry-contents-loop(get-all-entries *journal-1*)))

(defun get-all-bookmarked--entries-user-input()
    (entry-contents-loop(get-all-bookmarked-entries *journal-1*)))

(defun edit-title-of-entry-user-input()
    (edit-title (search-for-entry-user-input) (prompt-read "Enter new title"))
    (print "Edited title")
)
(defun edit-text-of-entry-user-input()
    (edit-text (search-for-entry-user-input) (prompt-read "Enter new text"))
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
  (defvar *db*)
   (setf *db* (make-instance 'database :filepath "./journal.ldb"))
)

(defun save-user-journal()
  (save-journal *db*  *journal-1*)
)

(defun load-user-journal()
  (if (not (probe-file (filepath *db*)))
    (save-user-journal)
  ) 
  (load-journal *db*  *journal-1*)
)
  
(defun prompt-user ()
    (let ((user-input ""))
    
    (setf user-input (prompt-read "Do you want to 
    'add entry[1]', 'searchForEntry[2]', 
    'remove entry[3]', 'get all entries[4], 
    get all bookedmared entries[5], edit title of entry[6], edit text of entry[7], 
    add book mark to entry[8], or remove bookmark[9] "))
        
        (cond
            ((= (parse-integer user-input) 1 ) (add-entry-user-input))
            ((= (parse-integer user-input) 2 ) (print(search-for-entry-user-input)))
            ((= (parse-integer user-input) 3 ) (remove-entry-user-input))
            ((= (parse-integer user-input) 4 ) (print(get-all-entries-user-input)))
            ((= (parse-integer user-input) 5 ) (print(get-all-bookmarked--entries-user-input)))
            ((= (parse-integer user-input) 6 ) (edit-title-of-entry-user-input))
            ((= (parse-integer user-input) 7 ) (edit-text-of-entry-user-input))
            ((= (parse-integer user-input) 8 ) (add-bookmark-to-entry))
            ((= (parse-integer user-input) 9 ) (remove-bookmark-from-entry))
        )(save-user-journal)
        )
  
)

(defun main()
  (create-database)
  (create-journal (prompt-read "Enter name of journal"))
  (load-user-journal)
  (loop (prompt-user)
      (if (not (y-or-n-p "Do you want to do something else? [y/n]: ")) (return))))


;(main)
