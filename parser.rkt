#lang racket
(provide make-parser
         expect maybe
         exn:parser-error?)

; I'd rather this was not mutable, alas,
;  I don't know how to do this and keep parameters...
;  It'd solve many issues, however (as in maybe)
(struct parser-impl (tokens) #:mutable)
(struct exn:parser-error exn ())

(define (get-cur-tokens)
  (parser-impl-tokens (current-parser)))

(define (set-cur-tokens! tokens)
  (set-parser-impl-tokens! (current-parser) tokens))

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

; thunking `maybe`
(define-syntax-rule (maybe rule)
  (maybe-impl (lambda () rule)))

(define (maybe-impl rule)
  (let ([orig-tokens (get-cur-tokens)])
    (with-handlers ([exn:parser-error? (lambda (e)
                                         (set-cur-tokens! orig-tokens)
                                         #f)])
      (rule))))

(define (expect token-type)
  (match (get-cur-tokens)
    [(list-rest (list type value) rest)
     #:when (eq? type token-type)
     (set-cur-tokens! rest)
     (list type value) #| pls gief as pattern ;( |#]
    [else (raise (exn:parser-error
                  (string-append "unable to match token: " (symbol->string token-type))
                  (current-continuation-marks)))]))
