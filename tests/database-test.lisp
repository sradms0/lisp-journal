(defpackage database-test
  (:use :cl 
        :rove 
        :uiop
        :database-package
        :entry-package  
        :journal-package))
(in-package :database-test)

(defun remove-journal-storage ()
    (when (probe-file "./journal-storage") 
        (uiop:delete-directory-tree #p"./journal-storage/" :validate t)))
  
(defun make-test-db ()
  (make-database))
  
(defun make-test-journal (&optional (test-owner "test-owner"))
  (make-instance 'journal :owner test-owner))

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
  (testing "storage directory is created"
           (remove-journal-storage)
           (make-test-db)
           (ok (equal (not (probe-file "./journal-storage/")) nil))))

(deftest save-test
         (testing "saving empty-journal"
                  (remove-journal-storage)
                  (save-journal (make-test-db) (make-test-journal))
                  (ok (equal 
                        (with-open-file (in "./journal-storage/test-owner.ldb")
                           (with-standard-io-syntax 
                             (format nil "~{~A~}"(read in))))
                        "")))
         (testing "saving full-journal"
                  (remove-journal-storage)
                  (save-journal (make-test-db) (add-n-test-entries (make-test-journal) 50))
                  (ok (= 
                        (with-open-file (in "./journal-storage/test-owner.ldb")
                           (with-standard-io-syntax 
                             (length (read in))))
                        50)))
         (testing "saving two journals"
                  (remove-journal-storage)
                  (let ((test-db (make-test-db)))
                      (save-journal test-db (add-n-test-entries (make-test-journal "test-owner-1") 40))
                      (save-journal test-db (add-n-test-entries (make-test-journal "test-owner-2") 20))
                      (ok (= 
                            (with-open-file (in "./journal-storage/test-owner-1.ldb")
                               (with-standard-io-syntax 
                                 (length (read in))))
                            40))
                      (ok (= 
                            (with-open-file (in "./journal-storage/test-owner-2.ldb")
                               (with-standard-io-syntax 
                                 (length (read in))))
                            20)))))   

;(deftest load-test
         ;(testing "loading empty-journal file"
                  ;(let ((test-db (make-test-db))
                        ;(test-journal (make-test-journal)))
                    ;(save-journal test-db test-journal)
                    ;(load-journal test-db test-journal)
                    ;(ok (= (length (entries test-journal)) 0))))

         ;(testing "loading full-journal file"
                  ;(let ((test-db (make-test-db))
                        ;(test-journal (make-test-journal)))
                    ;(save-journal (make-test-db) (add-n-test-entries (make-test-journal) 50))
                    ;(load-journal test-db test-journal)
                    ;(ok (= (length (entries test-journal)) 50))))

         ;(testing "loading non-existent journal file"
                  ;(if (probe-file "./tests/test.ldb") 
                      ;(delete-file "./tests/test.ldb"))
                  ;(ok (signals (load-journal (make-test-db) (make-test-journal))))))
