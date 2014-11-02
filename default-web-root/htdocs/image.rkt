#lang slideshow

(require racket/draw)


(define (my-spline x1 y1)
  (dc (lambda (dc x y)
        (send dc draw-spline
              x y
              (+ x 20) (+ y 80)
              (+ x 100) (+ y 100)))
      x1 y1))


(define pict (my-spline 100 200))


;(define target (make-bitmap 400 200)) ; A 30x30 bitmap
;(define image-dc (new bitmap-dc% [bitmap target]))

(define (my-image x1 y1)
(dc (lambda (image-dc x y)
      
(send image-dc set-brush "green" 'transparent)
(send image-dc erase)

(for ( (row '(0 1 2 3))) 
  (for ( (col '(0 1 2 3)))
    (send image-dc draw-rectangle
          (* col 100) (* row 100)
          100 100) 
    (let ( (rot-val (* 0.5 (+ col (* row 4))))
           (tran-x (+ 30 (* col 100)))
           (tran-y (+ 50 (* row 100)))
           )
      
      (send image-dc translate tran-x tran-y)
      (send image-dc rotate  rot-val)
      (send image-dc draw-text "world" -20 0)
      (send image-dc rotate  (* -1 rot-val))
      (send image-dc translate (* -1 tran-x) (* -1 tran-y))
      
      )
    )
  )
      
      ) x1 y1))

(define aaa (my-image 400 400))
      
;(send target save-file "/home/ckk/Desktop/box.png" 'png)
aaa