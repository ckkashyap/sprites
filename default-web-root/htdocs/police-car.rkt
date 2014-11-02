#lang racket

(require racket/draw)

(define sprite-width 100)
(define sprite-height 100)
(define sprites-in-a-row 2)
(define sprites-in-a-col 5)

(define (ninety-percent-of x) (* x 0.9))
(define (eighty-percent-of x) (* x 0.8))
(define (seventy-percent-of x) (* x 0.7))
(define (thirty-percent-of x) (* x 0.3))
(define (twenty-percent-of x) (* x 0.2))
(define (ten-percent-of x) (* x 0.1))
(define (half-of x) (/ x 2))

(define car-body-width (seventy-percent-of sprite-width))
(define car-body-height (thirty-percent-of sprite-height))
(define car-body-x (half-of (- sprite-width car-body-width)))
(define car-body-y (half-of sprite-height))


(define car-top-polygon (map (lambda (p) (make-object point% (car p) (cadr p) )) 
			     (list 
				(list (+ car-body-x (ten-percent-of car-body-width)) car-body-y)
				(list (+ car-body-x (twenty-percent-of car-body-width)) (- car-body-y (half-of car-body-height)))
				(list (+ car-body-x (eighty-percent-of car-body-width)) (- car-body-y (half-of car-body-height)))
				(list (+ car-body-x (ninety-percent-of car-body-width)) car-body-y)
			       )))

(define bitmap-width (* sprites-in-a-col sprite-width))
(define bitmap-height (* sprites-in-a-row sprite-height))

(define target (make-bitmap bitmap-width bitmap-height)) 
(define image-dc (new bitmap-dc% [bitmap target]))

      
(send image-dc set-brush "green" 'transparent)
(send image-dc erase)

(for ( (row sprites-in-a-row)) 
  (for ( (col sprites-in-a-col))
    (send image-dc draw-rectangle
          (* col sprite-width) (* row sprite-height)
          sprite-width sprite-height) 
    (let ( (rot-val 0)
           (tran-x (+ 0 (* col sprite-width)))
           (tran-y (+ 0 (* row sprite-height)))
	   (current-transformation (send image-dc get-transformation))
           )
      
      (send image-dc translate tran-x tran-y)
      (send image-dc rotate rot-val)

      (send image-dc draw-rounded-rectangle car-body-x car-body-y car-body-width car-body-height )
      (send image-dc draw-polygon car-top-polygon)


      (send image-dc set-transformation current-transformation)
      
      )
    )
  )
      
(send target save-file "car.png" 'png)
