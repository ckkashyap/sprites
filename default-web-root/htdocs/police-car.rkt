#lang slideshow
;#lang racket

(require racket/draw)



(define sprite-width 100)
(define sprite-height 100)
(define sprites-in-a-row 3)
(define sprites-in-a-col 6)

(define (ninety-percent-of x) (* x 0.9))
(define (eighty-percent-of x) (* x 0.8))
(define (seventy-percent-of x) (* x 0.7))
(define (sixty-percent-of x) (* x 0.7))
(define (thirty-percent-of x) (* x 0.3))
(define (twenty-percent-of x) (* x 0.2))
(define (ten-percent-of x) (* x 0.1))
(define (five-percent-of x) (* x 0.05))
(define (half-of x) (/ x 2))

;(define car-body-width (half-of sprite-width))
(define car-body-width 50)
(define car-body-height (half-of car-body-width))
(define car-body-x (half-of (- sprite-width car-body-width)))
(define car-body-y (half-of sprite-height))

(define my-color-car-front (make-object color% 150 150 150 1))
(define my-color-car-wind-sheild (make-object color% 200 200 140 1))
(define no-brush (new brush% [style 'transparent]))
(define blue-brush (new brush% [color "blue"]))
(define yellow-brush (new brush% [color my-color-car-wind-sheild]))
(define black-brush (new brush% [color my-color-car-front] [ style 'cross-hatch ]))

(define lambda-point-map (lambda (p) (make-object point% (car p) (cadr p) )) )

(define car-bonut-polygon (map lambda-point-map
                               (list 
                                (list car-body-x car-body-y)
                                (list (+ car-body-x car-body-width) car-body-y)
                                (list (+ car-body-x car-body-width (twenty-percent-of car-body-width)) (+ car-body-y (half-of car-body-width)))
                                (list (- car-body-x (twenty-percent-of car-body-width)) (+ car-body-y (half-of car-body-width)))
                                )))


(define car-top-polygon (map lambda-point-map
                             (list 
                              (list car-body-x car-body-y)
                              (list (+ car-body-x (ten-percent-of car-body-width)) (- car-body-y (half-of car-body-height)))
                              (list (+ car-body-x (ninety-percent-of car-body-width)) (- car-body-y (half-of car-body-height)))
                              (list (+ car-body-x car-body-width) car-body-y)
                              )))

(define car-front-polygon (map lambda-point-map
                               (list
                                (list (+ car-body-x car-body-width (twenty-percent-of car-body-width)) (+ car-body-y (half-of car-body-width)))
                                (list (+ car-body-x car-body-width (twenty-percent-of car-body-width)) (+ car-body-y (sixty-percent-of car-body-width)))
                                
                                (list (- car-body-x (twenty-percent-of car-body-width)) (+ car-body-y (sixty-percent-of car-body-width)))                                
                                (list (- car-body-x (twenty-percent-of car-body-width)) (+ car-body-y (half-of car-body-width)))                                
                                
                                )))


(define bitmap-width (* sprites-in-a-col sprite-width))
(define bitmap-height (* sprites-in-a-row sprite-height))

;(define target (make-bitmap bitmap-width bitmap-height)) 
;(define image-dc (new bitmap-dc% [bitmap target]))

(dc (lambda (image-dc x y) 
      
      
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
            
            (send image-dc set-brush yellow-brush)
            (send image-dc draw-polygon car-top-polygon)
            
            
            (send image-dc set-brush blue-brush)
            (send image-dc draw-polygon car-bonut-polygon)
            
            
            (send image-dc set-brush black-brush)
            (send image-dc draw-polygon car-front-polygon)
            
            (let* (
                  [light-x1 (+ car-body-x (twenty-percent-of car-body-width))]
                  [light-y (- car-body-y (seventy-percent-of car-body-height))]
                  [light-width (twenty-percent-of car-body-width)]
                  [light-height (ten-percent-of car-body-width)]
                  
                  [light-x2 (+ light-x1 light-width)]
                  [light-x3 (+ light-x2 light-width)]
                  
                  )
              (send image-dc draw-rounded-rectangle  light-x1  light-y light-width light-height )
              (send image-dc draw-rounded-rectangle  light-x2  light-y light-width light-height )
              (send image-dc draw-rounded-rectangle  light-x3  light-y light-width light-height )
              
              )
            
            
            
            
            (send image-dc set-brush no-brush)            
            (send image-dc set-transformation current-transformation)
            
            
            
            
            )
          )
        )
      
      ) 300 200 )
;(send target save-file "car.png" 'png)
