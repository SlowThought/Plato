#lang racket
#| dwrt.rkt -- Macros for finding derivatives. Not complete, just in context of Plato project
   Written by Patrick King, all rights reserved

  DEVELOPMENT ON HOLD. Meant to speed up development, but hung up on derivative of negatives. Bah. |#

(provide dwrt)
(require (for-syntax syntax/identifier syntax/parse)
         racket/math)

;; Just enough calculus for the Plato project. Assumptions are made in the context of
;; Lagrangians (bare variables are assumed to be independent). Read dwrt as "derivative
;; with respect to"

(define-syntax (dwrt stx)
  
  (define-syntax-class derivative
      #:description "valid derivative variable" ; This is terrible. See what errors we get. Do better.
      (pattern (x:id exp:expr)))
  
  (syntax-parse stx
    [(dwrt x y:number) #'0] ; Constants
    [(dwrt x y:id)          ; Bare variables
     (if (eq? (identifier->symbol #'x)
              (identifier->symbol #'y))
         #'1 #'0)]
    ; Addition   
    [(dwrt x (+ y:expr)) #'(dwrt x y)]
    [(dwrt x (+ y:expr z:expr ...))
     #'(+ (dwrt x y)(dwrt x (+ z ...)))]
    ; Subtraction/negation
    [(dwrt x (- y))
     #'(- (dwrt x y))]
    [(dwrt x (- y z ...))
     #'(dwrt x (- y (+ z ...)))]
    [(dwrt x (- y z))
     #'(- (dwrt x y) (dwrt x z))]
    
    
    ))
;;     ; Multiplication
;;     [(dwrt x (* y z ...))
;;      #'(+ (* (dwrt x y) z ...) (* y (dwrt x (* z ...))))]
;;     [(dwrt x (* y))
;;      #'(dwrt x y)]
;;     ; Inversion (division not implemented)
;;     [(dwrt x (/ y ...))
;;      #'(- (/ (dwrt x (* y ...)) (sqr (* y ...))))]
;;     ; Trig
;;     [(dwrt x (sin y))
;;      #'(* (cos y)(dwrt x y))]
;;     [(dwrt x (cos y))
;;      #'(* -1 (sin y)(dwrt x y))]
;;     ; Powers
;;     [(dwrt x (sqr y))
;;      #'(* 2 y (dwrt x y))]
;;     [(dwrt x (sqrt y))
;;      #'(/ (dwrt x y) -2 y (sqrt y))]

;; (define-syntax-rule (minus x ...) (- x ...))

(module* test #f
   (require test-engine/racket-tests)
  ;; Variables
  (define x 9)
  (define y x)
;;   ; Derivative of self should be 1
;;   (check-expect (dwrt x x) 1) 
;;   ; Derivative of constants or independent variables should be 0
;;   (check-expect (dwrt x 1) 0)
;;   (check-expect (dwrt x y) 0)
;;   ; Derivative of sums
;;   (check-expect (dwrt x (+ x y 2)) 1)
;;   (check-expect (dwrt x (+ y x x 3)) 2)
  ; differences
;;   (check-expect (dwrt x (- y)) 0)
;;   (check-expect (dwrt x (- y x)) -1)
  (check-expect (dwrt x (- x)) -1)
  (test))