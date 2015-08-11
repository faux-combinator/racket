#lang racket
(require rackunit rackunit/text-ui)
(require "tests/lexer.rkt")

(display "# lexer\n")
(run-tests lexer-tests)
