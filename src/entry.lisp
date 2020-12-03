(defpackage entry-package 
  (:use :cl :local-time)
  (:export :entry
           :date
           :title 
           :text
           :bookmark))
(in-package :entry-package)

(defclass entry ()
  ((date
     :accessor date
     :initform (local-time:now))
   (title 
     :initarg :title
     :accessor title
     :initform (error "must supply entry-title"))
   (text 
     :initarg :text
     :accessor text
     :initform (error "must supply entry-text"))
   (bookmark
     :initarg :bookmark
     :accessor bookmark
     :initform nil))
  (:documentation "An entry to store one's thoughts"))

