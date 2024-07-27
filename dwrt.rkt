#lang racket
#| dwrt.rkt -- Macros for finding derivatives. Not complete, just in context of Plato project
   Written by Patrick King, all rights reserved |#
(require syntax/identifier)
(provide dwrt)
;; Just enough calculus for the Plato project. Assumptions are made in the context of
;; Lagrangians. Read dwrt as "derivative with respect to"


(define-syntax (dwrt stx) 
  (syntax-case stx (+ - * / cos sin sqr sqrt) ; functions to be imported
    ; Addition
    [(dwrt x (+ y z ...))
     #'(+ (dwrt x (+ z ...))(dwrt x y))]
    [(dwrt x (+ y)) #'(dwrt x y)]
    ; Subtraction/negation
    [(dwrt x (- y z ...))
     #'(- (dwrt x y)(dwrt x (+ z ...)))]
    [(dwrt x (- y))
     #'(- (dwrt x y))]
    ; Multiplication
    [(dwrt x (* y z ...))
     #'(+ (* (dwrt x y) z ...) (* y (dwrt x (* z ...))))]
    [(dwrt x (* y))
     #'(dwrt x y)]
    ; Inversion (division not implemented)
    [(dwrt x (/ y ...))
     #'(- (/ (dwrt x (* y ...)) (sqr (* y ...))))]
    ; Trig
    [(dwrt x (sin y))
     #'(* (cos y)(dwrt x y))]
    [(dwrt x (cos y))
     #'(* -1 (sin y)(dwrt x y))]
    ; Powers
    [(dwrt x (sqr y))
     #'(* 2 y (dwrt x y))]
    [(dwrt x (sqrt y))
     #'(/ (dwrt x y) -2 y (sqrt y))]
    ; Bare numbers and variables
    [(dwrt x y)
     (if (identifier? #'x)
         (if (number? #'y) #'0
             (if (identifier? #'y)
                 (if (eq? (identifier->symbol #'x) (identifier->symbol #'y)) #'1 #'0)
                 (raise-syntax-error #f "2nd argument of unknown/unhandled type" stx)))        
         (raise-syntax-error #f "first argument not an identifier" stx))]))

(module* test #f
  ;; Variables
  (define x 9)
  (define y x)
  ; Derivative of self should be 1
  (dwrt x x))