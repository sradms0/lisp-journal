(defpackage journal-test
  (:use :cl :rove :journal-package :entry-package))
(in-package :journal-test)

(defun make-test-journal ()
  (make-instance 'journal :owner "test-owner"))

(defun make-test-entry ()
  (make-instance 'entry :title "test-title" :text "test-text"))

(defun add-test-entry (test-journal)
  (add-entry test-journal (make-test-entry)))
 
(deftest add-entry-test
         (testing "add one entry" 
                  (ok (= (length (add-test-entry (make-test-journal))) 1))))

;; NOTE: To run this test file, execute `(asdf:test-system :my-project)' in your Lisp.
