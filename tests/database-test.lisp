(defpackage database-test
  (:use :cl 
        :rove 
        :database-package
        :entry-package  
        :journal-package))
(in-package :database-test)

(deftest constructor-test
  (testing "no file given" (ok (signals (make-instance 'database)))))
