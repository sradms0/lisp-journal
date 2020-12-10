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

(deftest remove-entry-test
         (testing "remove existing entry"
                  (ok (equal
                        (entry-package:title (remove-entry (add-n-test-entries (make-test-journal) 5) "test-title 1"))
                        "test-title 1")))
         (testing "remove non-existing entry"
                  (ok (signals
                        (entry-package:title (remove-entry (add-n-test-entries (make-test-journal) 5) "test-title 6")))))
         (testing "remove entry from empty journal"
                  (ok (signals
                        (entry-package:title (remove-entry (make-test-journal) "test-title 6"))))))

(deftest search-for-entry-test
        (testing "search for existing entry"
          (ok (equal 
                (entry-package:title (search-for-entry (add-n-test-entries (make-test-journal) 5) "test-title 3"))
                "test-title 3")))
        (testing "search for non-existing entry"
          (ok (signals
                (entry-package:title (search-for-entry (add-n-test-entries (make-test-journal) 5) "test-title 6"))
                )))
        (testing "search for empty journal"
          (ok (signals
                (entry-package:title (search-for-entry(make-test-journal)  "test-title 6"))
                )))
                
)
