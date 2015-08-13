#lang racket
(require rackunit)
(require "../helpers.rkt")

(provide helpers-tests)

(define helpers-tests
  (test-suite
   "helpers tests"

   (test-case
    "tests for aif"
    (check-equal? 1 (aif 1 it 0)))

   (test-case
    "tests for awhile"
    (let ([x #t])
      (awhile x
              (check-equal? #t x)
              (set! x #f))
      (check-equal? #f x))

    (let ([x 5])
      (awhile x
              (check-equal? #t (number? x)) ; XXX ugly
              (if (= 0 x)
                  (set! x #f)
                  (set! x (- x 1))))
      (check-equal? #f x)))

   (test-case
    "tests for capturing-awhile"
    (let ([x 5])
      (check-equal?
       (list 5 4 3 2 1 0)
       (capturing-awhile x
                         (if (= 0 x)
                             (set! x #f)
                             (set! x (- x 1)))
                         it))))
   ))
