;;; -*- Mode: Lisp; Package: CLIM-POSTSCRIPT -*-

;;;  (c) copyright 2002 by
;;;           Alexey Dejneka (adejneka@comail.ru)

;;; This library is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU Library General Public
;;; License as published by the Free Software Foundation; either
;;; version 2 of the License, or (at your option) any later version.
;;;
;;; This library is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Library General Public License for more details.
;;;
;;; You should have received a copy of the GNU Library General Public
;;; License along with this library; if not, write to the
;;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;;; Boston, MA  02111-1307  USA.

(in-package :clim-postscript)

(defparameter *paper-sizes*
  '((:letter 612 . 792)
    (:legal 612 . 1008)
    (:a0 2380 . 3368)
    (:a1 1684 . 2380)
    (:a2 1190 . 1684)
    (:a3 842 . 1190)
    (:a4 595 . 842)
    (:a5 421 . 595)
    (:a6 297 . 421)
    (:a7 210 . 297)
    (:a8 148 . 210)
    (:a9 105 . 148)
    (:a10 74 . 105)
    (:b0 2836 . 4008)
    (:b1 2004 . 2836)
    (:b2 1418 . 2004)
    (:b3 1002 . 1418)
    (:b4 709 . 1002)
    (:b5 501 . 709)
    (:11x17 792 . 1224)))

(defun paper-size (name)
  (let ((size (cdr (assoc name *paper-sizes*))))
    (unless size
      (error "Unknown paper size: ~S." name))
    (values (car size) (cdr size))))

(defun paper-region (paper-size-name orientation)
  (multiple-value-bind (width height) (paper-size paper-size-name)
    (when (eq orientation :landscape)
      (rotatef width height))
    (make-rectangle* 0 0 width height)))

(defun make-postscript-transformation (paper-size-name orientation)
  (multiple-value-bind (width height) (paper-size paper-size-name)
    (let* ((height/2 (/ height 2))
           (transform (make-reflection-transformation*
                       0 height/2
                       width height/2)))
      (case orientation
        (:portrait transform)
        (:landscape (compose-transformation-with-rotation
                     transform
                     (/ pi 2) (make-point (/ width 2) height/2)))
        (t (error "Unknown orientation"))))))