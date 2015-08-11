#lang racket
(require rackunit rackunit/text-ui)
(require "tests/lexer.rkt" "tests/parser.rkt")

(display "# lexer\n")
(run-tests lexer-tests)
(display "# parser\n")
(run-tests parser-tests)
