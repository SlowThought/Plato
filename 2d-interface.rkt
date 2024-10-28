#lang racket
#| "2d-interface.rkt" provides picts implementing orthographic view of particle model
   Written by Patrick King, all rights reserved |#
(require pict "./physics.rkt")
(provide draw-particles-2d)

;;; View parameters
(define vertex-size 10); At z == 0. Observer assumed at z == 2. Size will scale w/ z
(define vertices? #t)
(define edges? #f)
(define faces? #f)
(define unit-circle? #t)
(define unit-circle-thickness 1)
;(define (view-parameter-dialog)

;;; Derivatives of window size

(define (diameter window-size vertex-size) (- window-size vertex-size)) ; ensure room to depict vertices
                                                                        ; at edge
;;; Draw elements of 2-D picture
(define (max-square parent)
  (if parent
      (min (send parent get-width)
           (send parent get-height))
      300))

(define (draw-unit-circle frame size)
  (pin-over frame (/ vertex-size 2)(/ vertex-size 2)
            (circle (diameter size vertex-size) #:border-width unit-circle-thickness)))

(define (draw-vertex x y z frame size)
  (define dia (/(* 2 vertex-size)(- 2 z))) ; Scale size for z distance
  (define mag (/ (diameter size vertex-size) 2)) ; Scale (magnify) pixel coordinates
  (define l (- (+ (/ size 2) (* mag x)) (/ dia 2)))
  (define m (- (- (/ size 2) (* mag y)) (/ dia 2)))
  (pin-over frame l m
            (disk dia #:color "red")))

;;; Draw current state of particles
(define (draw-particles-2d parent)
  (define window-size (max-square parent))
  (define my-pict (blank window-size window-size))
  (cond [unit-circle?
         (set! my-pict (draw-unit-circle my-pict window-size))])
  (cond [vertices?
         (for [(i (in-range n_particles))]
           (set! my-pict (draw-vertex (x (ϕ i) (θ i))
                                      (y (ϕ i) (θ i))
                                      (z (θ i))
                                      my-pict window-size)))])                
  my-pict)

(module+ test
  (push-random-particle!)
  (push-random-particle!)
  (draw-particles-2d #f))

