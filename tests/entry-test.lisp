(defpackage entry-test
  (:use :cl :rove :entry-package))
(in-package :entry-test)

(deftest constructor-test 
         (testing "title nor text given" (ok (signals (make-instance 'entry))))
         (testing "no title given") (ok (signals (make-instance 'entry :text "test")))
         (testing "no text given") (ok (signals (make-instance 'entry :title "test"))))

;; NOTE: To run this test file, execute `(asdf:test-system :my-project)' in your Lisp.

(defun make-test-entry (suffix)
  (make-instance 'entry 
                 :title (concatenate 'string "test-title " suffix) 
                 :text (concatenate 'string "test-text " suffix)))

(defun make-n-test-entries (n)
  (let ((test-entries ()))
    (dotimes (i n)
      (setf  test-entries (cons (make-test-entry (write-to-string (+ i 1))) test-entries)))
    test-entries))

    
(deftest edit-title-test
	(testing "edit title"
		(ok (equal
			(entry-package:title (edit-title (make-test-entry "1") "title-edited"))
      "title-edited")))
  (testing "blank title error"
    (ok (signals
      (entry-package:title (edit-title (make-test-entry "1") "")))))
)

(deftest edit-text-test
	(testing "edit text"
		(ok (equal
			(entry-package:text (edit-text (make-test-entry "1") "text-edited"))
      "text-edited")))
)


