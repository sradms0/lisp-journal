(defpackage journal-test
  (:use :cl :rove :journal-package :entry-package))
(in-package :journal-test)

(defun make-test-journal ()
  (make-instance 'journal :owner "test-owner"))

(defun make-test-entry (suffix)
  (make-instance 'entry 
                 :title (concatenate 'string "test-title " suffix) 
                 :text (concatenate 'string "test-text " suffix)))

(defun add-test-entry (test-journal suffix)
  (add-entry test-journal (make-test-entry suffix)) 
  test-journal)

(defun add-n-test-entries (test-journal n)
  (dotimes (i n)
    (add-test-entry test-journal (write-to-string (+ i 1))))
  test-journal)
  
 
(deftest add-entry-test
         (testing "add one entry" 
                  (ok (= (length (entries (add-test-entry (make-test-journal) "1"))) 1)))
         (testing "add multiple entries"
                  (ok (= (length (entries (add-n-test-entries (make-test-journal) 10))) 10))))
                  
;; NOTE: To run this test file, execute `(asdf:test-system :my-project)' in your Lisp.
