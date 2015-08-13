#lang racket
(require rackunit rackunit/text-ui)
(require "tests/helpers.rkt" "tests/lexer.rkt" "tests/parser.rkt")

(display "# helpers\n")
(run-tests helpers-tests)
(display "# lexer\n")
(run-tests lexer-tests)
(display "# parser\n")
(run-tests parser-tests)
