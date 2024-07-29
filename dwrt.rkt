#lang racket
#| dwrt.rkt -- Macros for finding derivatives. Not complete, just in context of Plato project
   Written by Patrick King, all rights reserved |#

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
    
    ))
;;     ; Addition
;;     [(dwrt x (+ y z ...))
;;      #'(+ (dwrt x (+ z ...))(dwrt x y))]
;;     [(dwrt x (+ y)) #'(dwrt x y)]
;;     ; Subtraction/negation
;;     [(dwrt x (- y z ...))
;;      #'(- (dwrt x y)(dwrt x (+ z ...)))]
;;     [(dwrt x (- y))
;;      #'(- (dwrt x y))]
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


(module* test #f
  ;; Variables
  (define x 9)
  (define y x)
  ; Derivative of self should be 1
  (writeln (dwrt x x))
  ; Derivative of constants or independent variables should be 0
  (writeln (dwrt x 1))
  (writeln (dwrt x y)))
  ; Derivative of sums, is ANY of this working?
  ;(writeln (dwrt x (+ x y 2))))