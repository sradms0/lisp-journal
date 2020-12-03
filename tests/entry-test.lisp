(defpackage entry-test
  (:use :cl :rove :entry-package))
(in-package :entry-test)

(deftest constructor-test 
         (testing "title nor text given" (ok (signals (make-instance 'entry))))
         (testing "no title given") (ok (signals (make-instance 'entry :text "test")))
         (testing "no text given") (ok (signals (make-instance 'entry :title "test"))))

;; NOTE: To run this test file, execute `(asdf:test-system :my-project)' in your Lisp.
