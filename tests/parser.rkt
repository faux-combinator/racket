#lang racket
(require rackunit)
(require "../parser.rkt")

(provide parser-tests)

(define eq-token '(eq "="))
(define dash-token '(dash "="))
(define under-token '(under "="))

(define parser-tests
  (test-suite
   "parser test suite"

   (test-case
    "it can parse basic stuff"
    (define parser (make-parser
                    (expect 'eq)
                    #t
                    ))
    (check-equal? #t (parser `(,eq-token))))

   (test-case
    "it can parse several (different) tokens"
    (define parser (make-parser
                    (expect 'eq)
                    (expect 'dash)
                    (expect 'under)
                    #t))
    (check-equal? #t (parser `(,eq-token ,dash-token ,under-token))))
   ))
