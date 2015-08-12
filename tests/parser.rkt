#lang racket
(require rackunit)
(require "../parser.rkt")

(provide parser-tests)

(define lparen-token '(lparen "("))
(define rparen-token '(rparen ")"))
(define eq-token '(eq "="))
(define dash-token '(dash "-"))
(define under-token '(under "_"))

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

   (test-case
    "it can parse maybe tokens"
    (define parser (make-parser
                    (expect 'lparen)
                    (define v (maybe (expect 'eq)))
                    (expect 'rparen)
                    v))
    (check-equal? #f (parser `(,lparen-token ,rparen-token))
                  "it can still parse the basic version")

    (check-equal? eq-token (parser `(,lparen-token ,eq-token ,rparen-token))
                  "it can also parse the `maybe` token"))

   (test-case
    "it fails to parse invalid code"
    (define parser (make-parser
                    (expect 'anything)))
    (check-exn exn:parser-error?
               (lambda () (parser '()))))
   ))
