(defpackage entry-package 
  (:use :cl :local-time)
  (:export :entry
           :date
           :title 
           :text
           :bookmark
           :add-bookmark
           :edit-title
           :edit-text))
(in-package :entry-package)

(defclass entry ()
  ((date
     :initarg :date
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


(defmethod edit-title((object entry) titleIn)
    "Changes the title of given entry"
    (cond ((= (length titleIn) 0) (error "must supply entry-title"))
          (t (setf (title object) titleIn) (identity object))))


(defmethod edit-text((object entry) textIn)
    "Changes the text of given entry"
    (cond ((= (length textIn) 0) (error "must supply entry-text"))
          (t (setf (text object) textIn) (identity object))))

(defmethod add-bookmark ((object entry))
  nil)
  
