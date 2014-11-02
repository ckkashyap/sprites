#lang racket

(require racket/draw)

(define sprite-width 100)
(define sprite-height 100)
(define sprites-in-a-row 4)
(define sprites-in-a-col 4)

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
    (let ( (rot-val (* -0.4 (+ col (* row 4))))
           (tran-x (+ 45 (* col sprite-width)))
           (tran-y (+ 50 (* row sprite-height)))
	   (current-transformation (send image-dc get-transformation))
           )
      
      (send image-dc translate tran-x tran-y)
      (send image-dc rotate  rot-val)
      (send image-dc draw-text "Hello" -15 -5)
      (send image-dc set-transformation current-transformation)
      
      )
    )
  )
      
(send target save-file "box.png" 'png)
