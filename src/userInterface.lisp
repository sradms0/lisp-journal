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
    
    )

(defun search-for-entry-user-input()
  (search-for-entry
     *journal-1* (prompt-read "Enter Title to find")))

(defun remove-entry-user-input()
  (remove-entry
    *journal-1* (prompt-read "Enter Title to remove")))    

(defun get-all-entries-user-input()
    (get-all-entries *journal-1*))

(defun get-all-bookmarked--entries-user-input()
    (get-all-bookmarked-entries *journal-1*))

(defun edit-title-of-entry-user-input()
    (edit-title (search-for-entry-user-input) (prompt-read "Enter new title"))
)
(defun edit-text-of-entry-user-input()
    (edit-text (search-for-entry-user-input) (prompt-read "Enter new text"))
)  

(defun create-database()
  (defvar *db*)
   (setf *db* (make-instance 'database :filepath "./journal.ldb"))
)

(defun save-user-journal()
  (save-journal *db*  *journal-1*)
)

(defun load-user-journal()
  (load-journal *db*  *journal-1*)
)
  
(defun prompt-user ()
    (let ((user-input ""))
    
    (setf user-input (prompt-read "Do you want to 
    'add entry[1]', 'searchForEntry[2]', 
    'remove entry[3]', 'get all entries[4], 
    get all bookedmared entries[5], edit title of entry[6], or edit text of entry[7] "))
        
        (cond
            ;;((= (parse-integer user-input) 0 ) (print(create-journal (prompt-read "Enter name of journal"))))
            ((= (parse-integer user-input) 1 ) (add-entry-user-input))
            ((= (parse-integer user-input) 2 ) (print(search-for-entry-user-input)))
            ((= (parse-integer user-input) 3 ) (remove-entry-user-input))
            ((= (parse-integer user-input) 4 ) (print(get-all-entries-user-input)))
            ((= (parse-integer user-input) 5 ) (print(get-all-bookmarked--entries-user-input)))
            ((= (parse-integer user-input) 6 ) (print(edit-title-of-entry-user-input)))
            ((= (parse-integer user-input) 7 ) (print(edit-text-of-entry-user-input)))
            
        )(save-user-journal)
    )

)

(defun main()
  (create-database)
  (create-journal "demo")
  (load-user-journal)
      (loop (prompt-user))
      
      (if (not (y-or-n-p "Do you want to do something else? [y/n]: ")) return))

(main)
