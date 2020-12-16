(defpackage journal-test
  (:use :cl :rove :journal-package :entry-package))
(in-package :journal-test)

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
  
 
(deftest add-entry-test
         (testing "add one entry" 
                  (ok (= (length (entries (add-test-entry (make-test-journal) "1"))) 1)))
         (testing "add multiple entries"
                  (ok (= (length (entries (add-n-test-entries (make-test-journal) 10))) 10)))
         (testing "add nil entry"
                  (ok (signals (add-entry (make-test-journal) nil))))) 

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
                (entry-package:title (search-for-entry (add-n-test-entries (make-test-journal) 5) "test-title 6")))))
                
        (testing "search for empty journal"
          (ok (signals
                (entry-package:title (search-for-entry(make-test-journal)  "test-title 6"))))))
                
(deftest get-all-entries-test
        (testing "get all entries"
                  (ok (= (length (get-all-entries (add-n-test-entries (make-test-journal) 10))) 10)))
        (testing "get all entries for an empty journal"
                  (ok (= (length (get-all-entries (add-n-test-entries (make-test-journal) 0))) 0)))
        (testing "make sure first entry is present"
          (ok (equal 
                (entry-package:title (nth 0 (get-all-entries (add-n-test-entries (make-test-journal) 5))))
                "test-title 1"))))
                
(deftest get-all-bookmarked-entries-test
         (testing "get entries from journal with one bookmarked"
                  (ok (= 
                        (length (get-all-bookmarked-entries 
                                  (add-test-entry (add-n-test-entries (make-test-journal) 10) "bookmarked!" t))) 
                        1)))
         (testing "get entries from journal of all bookmarked" 
                  (ok (= 
                        (length (get-all-bookmarked-entries 
                                  (add-n-test-entries (make-test-journal) 10 t))) 
                        10)))
         (testing "get entries from journal of none bookmarked" 
                  (ok (signals 
                        (length (get-all-bookmarked-entries 
                                  (add-n-test-entries (make-test-journal) 10)))))) 
                        
         (testing "get bookmarked entries from empty journal"
                  (ok (signals 
                        (get-all-bookmarked-entries (make-test-journal))))))
