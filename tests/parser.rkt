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
                    #t))
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
    "it parses `one-of` cases"
    (define parser (make-parser
                    (one-of (expect 'eq) (expect 'dash) (expect 'under))))
    (check-equal? eq-token (parser `(,eq-token))
                  "can parse one-of's first case")
    (check-equal? dash-token (parser `(,dash-token))
                  "can parse one-of's second case")
    (check-equal? under-token (parser `(,under-token))
                  "can parse one-of's third case")
    (check-exn exn:parser-error?
               (lambda () (parser `(,lparen-token)))
               "still can't parse wrong rules"))

   (test-case
    "it parses a `any-of`"
    (define parser (make-parser
                    (any-of (cadr (expect 'eq)))))
    (check-equal? '() (parser '())
                  "can parse zero occurences")
    (check-equal? '("=") (parser `(,eq-token))
                  "can parse one occurence")
    (check-equal? '("=" "=" "=") (parser `(,eq-token ,eq-token ,eq-token))
                  "can parse any number of occurences"))

   (test-case
    "it parses a `many-of`"
    (define parser (make-parser
                    (many-of (cadr (expect 'eq)))))
    (check-exn exn:parser-error?
               (lambda () (parser '()))
               "CANNOT parse zero occurences")
    (check-equal? '("=") (parser `(,eq-token))
                  "can parse one occurence")
    (check-equal? '("=" "=" "=") (parser `(,eq-token ,eq-token ,eq-token))
                  "can parse any number of occurences"))
   (test-case
    "it fails to parse invalid code"
    (define parser (make-parser
                    (expect 'anything)))
    (check-exn exn:parser-error?
               (lambda () (parser '()))))))
