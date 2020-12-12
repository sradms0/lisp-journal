(defpackage entry-package 
  (:use :cl :local-time)
  (:export :entry
           :date
           :title 
           :text
           :bookmark
           :edit-title
           :edit-text))
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


(defmacro removef (element place)
   `(setf ,place (remove ,element ,place)))

(defmethod edit-title((object entry) titleIn)
    "Changes the title of given entry"
    (setf (title object) titleIn)
)


(defmethod edit-text((object entry) text)
    "Changes the text of given entry"
    ()
)