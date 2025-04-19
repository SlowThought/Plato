#lang racket/gui
#| square.rkt -- Scratchpad to work out UI issues
   Written by Patrick King, all rights reserved |#

(require pict)

(define top (new frame%
                 [label "Square"]
                 [min-width 200]
                 [min-height 200]
                 [alignment '(center top)]))

(define toph (new horizontal-panel%
                  [parent top]))

(define lhs (new panel%
                 [parent toph]))

(define canvas (new canvas%
                    [parent lhs]
                    [paint-callback
                     (λ (canvas dc)
                       (draw-pict (insert-square-pict canvas) dc 0 0))]))

(define (insert-square-pict parent)
  (define size (- (min (send parent get-width)
                       (send parent get-height)) 5))
  (disk size #:color "Red"))
  
(define rhs (new vertical-panel%
                 [parent toph]
                 [min-width 50]
                 [stretchable-width #f]))

(new message%
     [parent rhs]
     [label "Button"])

(new message%
     [parent rhs]
     [label "Window"]) 

(send top show #t)

