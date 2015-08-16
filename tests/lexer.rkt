#lang racket
(require rackunit)
(require "../lexer.rkt")

(provide lexer-tests)

(define lexer-tests
  (test-suite
   "lexer test suite"

   (test-case
    "lexes the empty string"
    (check-eq? '() (lex '() "")))

   (test-case
    "it trims whitespace"
    (check-eq? '() (lex '() " ")))

   (test-case
    "it lexes a basic pattern"
    (check-equal? '((eq "="))
                  (lex '(("=" eq)) "=")))

   (test-case
    "it lexes a basic pattern several times"
    (check-equal? '((eq "=") (eq "="))
                  (lex '(("=" eq)) "==")))

   (test-case
    "it lexes a space-separated basic pattern several times"
    (check-equal? '((eq "=") (eq "="))
                  (lex '(("=" eq)) "=  =")))

   (test-case
    "it lexes multiple patterns"
    (check-equal? '((eq "=") (dash "-"))
                  (lex '(("=" eq) ("-" dash)) "=-")))
   (test-case
    "it lexes multiple, space-separated patterns"
    (check-equal? '((eq "=") (dash "-"))
                  (lex '(("=" eq) ("-" dash)) "=   -")))

   (test-case
    "it captures correctly"
    (check-equal? '((eq "==") (num "5"))
                  (lex '(("=+" eq) ("[0-9]+" num)) "== 5")))

   (test-case
    "it fails to lex invalid code"
    (check-exn exn:lexer-error?
               (lambda () (lex '() "anything"))))))
