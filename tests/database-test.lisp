(defpackage database-test
  (:use :cl 
        :rove 
        :database-package
        :entry-package  
        :journal-package))
(in-package :database-test)

(defun make-test-db ()
  (make-instance 'database :filepath "./tests/test.ldb"))
  
(defun make-test-journal ()
  (make-instance 'journal :owner "test-owner"))

(defun make-test-entry (suffix &optional with-bookmark)
  (make-instance 'entry 
                 :title (concatenate 'string "test-title " suffix) 
                 :text (concatenate 'string "test-text " suffix)
                 :bookmark with-bookmark))

(defun add-test-entry (test-journal suffix &optional with-bookmark)
  (add-entry test-journal (make-test-entry suffix with-bookmark)) 
  test-journal)

(defun add-n-test-entries (test-journal n &optional with-bookmark)
  (dotimes (i n)
    (add-test-entry test-journal (write-to-string (+ i 1)) with-bookmark))
  test-journal)

(deftest constructor-test
  (testing "no file given" (ok (signals (make-instance 'database)))))

(deftest save-test
         "NOTE: tests/test.ldb file with atleast () must exist for tests to run"
         
         (testing "saving empty-journal"
                  (save-journal (make-test-db) (make-test-journal))
                  (ok (equal 
                        (with-open-file (in "tests/test.ldb")
                           (with-standard-io-syntax 
                             (format nil "~{~A~}"(read in))))
                        "")))
         (testing "saving full-journal"
                  (save-journal (make-test-db) (add-n-test-entries (make-test-journal) 50))
                  (ok (= 
                        (with-open-file (in "tests/test.ldb")
                           (with-standard-io-syntax 
                             (length (read in))))
                        50))))
