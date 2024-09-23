#lang racket
#| "2d-interface.rkt" provides picts implementing orthographic view of particle model
   Written by Patrick King, all rights reserved |#
(require pict "./plato.rkt")

;;; View parameters
(define window-size 200)
(define vertex-size 10); At z == 0. Observer assumed at z == 2. Size will scale w/ z
(define vertices? #t)
(define edges? #f)
(define faces? #f)
(define unit-circle? #t)
(define unit-circle-thickness 1)
;(define (view-parameter-dialog)

;;; Draw current state of particles
(define (draw-particles-2d)
  (define diameter (- window-size vertex-size))
  (define my-pict (blank window-size window-size))
  (cond [unit-circle?
         (set! my-pict
               (pin-over my-pict 0 0
                (circle diameter #:border-width unit-circle-thickness)))])
  my-pict)      

(draw-particles-2d)