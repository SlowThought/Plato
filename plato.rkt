#lang racket/gui
#| plato.rkt -- Top module for the plato project, generating Platonic solids using Lagrangian mechanics
   Written by Patrick King, all rights reserved |#
(require pict racket/draw "./physics.rkt" "./2d-interface.rkt")

;;; UI parameters
(define button-width  50)
(define menu-height 15)
(define min-particle-display 200)

;;; Top panel
(define top (new frame%
                 [label "Plato"]
                 [min-width (+ min-particle-display button-width)]
                 [min-height(+ min-particle-display menu-height)]))

;;; Menus
(define main-menu (new menu-bar%
                       [parent top]))

(define file-menu (new menu%
                       [label "File"]
                       [parent main-menu]))

;;; Main window is split vertically into two panels
(define toph (new horizontal-panel%
                  [parent top]))

;; LHS handles the particle display

(define lhs (new panel%
                 [parent toph]))

(define canvas (new canvas%
                [parent lhs]
                [paint-callback
                 (λ (canvas dc)
                   (draw-pict (draw-particles-2d canvas) dc 0 0))]))

;; RHS handles buttons
(define rhs (new vertical-pane% ; This will contain sim control buttons
                 [parent toph]
                 [min-width (+ button-width 5)]
                 [stretchable-width #f]
                 [alignment '(center center)]))

(define ins-button (new button%
                        [parent rhs]
                        [label "Insert"]
                        [callback (λ (b e)
                                    (push-random-particle!)
                                    (send lhs show #t))]))

(define del-button (new button%
                        [parent rhs]
                        [label "Delete"]
                        [callback (λ (b e)
                                    (pop-particle!)
                                    (send lhs show #t))]))


(define running #f) ; semaphore to sim
(define sim void) ; this will be a thread

(define (run-sim!) ; the code in the thread
  (update-particles!)
  (send top show #t)
  (sleep dt)
  (cond [running (run-sim!)]))

(define run-button (new button%
                        [parent rhs]
                        [label "Run"]
                        [callback (λ (b e)
                                    (set! running #t)
                                    (set! sim (thread run-sim!)))]))

(define stop-button (new button%
                         [parent rhs]
                         [label "Stop"]
                         [callback (λ (b e)
                                     (set! running #f))]))
                        

(send top show #t)
