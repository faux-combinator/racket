#lang racket
(require racket/stxparam)

(provide it aif)

(define-syntax-parameter it
  (lambda (stx)
    (raise-syntax-error #f "`it` outside of `aif`" stx)))

(define-syntax-rule (aif condition then else)
  (let ([res condition])
    (syntax-parameterize ([it (make-rename-transformer #'res)])
      (if res then else))))
