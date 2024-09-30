#lang racket
#| plato.rkt -- Top module for the plato project, generating Platonic solids using Lagrangian mechanics
   Written by Patrick King, all rights reserved |#
(require racket/gui "./physics.rkt" "./2d-interface.rkt")

;;; UI parameters
(define button-width  50)
(define menu-height 15)

;;; Top panel
(define top (new frame%
                 [label "Plato"]
                 [min-width (+ window-size button-width)]
                 [min-height(+ window-size menu-height)]))

;;; Menus
(define main-menu (new menu-bar%
                       [parent top]))

(define file-menu (new menu%
                       [label "File"]
                       [parent main-menu]))

;;; Main window is split vertically into two panels
(define lhs (new panel% ; This will contain particle display
                 [parent top]
                 [alignment '(left center)]))

(define rhs (new vertical-panel% ; This will contain sim control buttons
                 [parent top]
                 [alignment '(right top)]))

(define ins-button (new button%
                        [parent rhs]
                        [label "Insert"]
                        [callback (λ (b e)
                                    (push-random-particle!))]))

(define del-button (new button%
                        [parent rhs]
                        [label "Delete"]
                        [callback (λ (b e)
                                    (pop-particle!))]))
                                    
                       
(send top show #t)
