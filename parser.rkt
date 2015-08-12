#lang racket
(provide make-parser
         expect)

; I'd rather this was not mutable, alas,
;  I don't know how to do this and keep parameters
(struct parser-impl (tokens) #:mutable)
(struct exn:parser-error exn ())

(define current-parser (make-parameter null))

; just a nifty pseudo-dsl...
(define-syntax-rule (make-parser rules ...)
  (do-parser (lambda () rules ...)))

; parameterizes the DSL body
;  to a new parser with the given tokens
(define (do-parser rules)
  (lambda (tokens)
    (parameterize ([current-parser (parser-impl tokens)])
      (rules))))

(define (expect token-type)
  (match (parser-impl-tokens (current-parser))
    [(list-rest (list type value) rest)
     #:when (eq? type token-type)
     (set-parser-impl-tokens! (current-parser) rest)
     (list type value) #| pls gief as pattern ;( |#]
    [else (raise (exn:parser-error
                  (string-append "unable to match token: " (symbol->string token-type))
                  (current-continuation-marks)))]))
