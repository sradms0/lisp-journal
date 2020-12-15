(ql:quickload "local-time")

(defsystem "lisp-journal"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("local-time")
  :components ((:module "src"
                :components
<<<<<<< Updated upstream
                ((:file "main" 
                        :depends-on 
                        ("database"
                         "entry" 
                         "journal"))
                 (:file "journal" 
                        :depends-on 
                        ("entry"))
=======
                ((:file "main" :depends-on ("entry" "journal"))
                 (:file "userInterface" :depends-on ("entry" "journal")) 
                 (:file "journal" :depends-on ("entry"))
>>>>>>> Stashed changes
                 (:file "entry")
                 (:file "database"
                        :depends-on
                        ("entry"
                         "journal"))
                 )))
  :description ""
  :in-order-to ((test-op (test-op "lisp-journal/tests"))))

(defsystem "lisp-journal/tests"
  :author ""
  :license ""
  :depends-on ("lisp-journal"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "database-test")
                 (:file "entry-test")
                 (:file "journal-test")
                 )))
  :description "Test system for lisp-journal"
  :perform (test-op (op c) (symbol-call :rove :run c)))
