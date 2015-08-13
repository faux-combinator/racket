#lang racket
(require racket/stxparam)

(provide it aif awhile capturing-awhile)

(define-syntax-parameter it
  (lambda (stx)
    (raise-syntax-error #f "`it` outside of `aif`" stx)))

(define-syntax-rule (aif condition then else)
  (let ([tmp condition])
    (syntax-parameterize ([it (make-rename-transformer #'tmp)])
      (if tmp then else))))

(define-syntax-rule (awhile condition body ...)
  (let loop ([tmp condition])
    (when tmp
        (syntax-parameterize ([it (make-rename-transformer #'tmp)])
          body ...)
        (loop condition))))

(define-syntax-rule (capturing-awhile condition body ...)
  (let loop ([tmp condition] [results '()])
    (if tmp
        (let ([val (syntax-parameterize ([it (make-rename-transformer #'tmp)])
                     body ...)])
          (loop condition (cons val results)))
        (reverse results))))
