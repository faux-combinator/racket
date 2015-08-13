#lang racket
(require "helpers.rkt")

(provide make-parser
         expect maybe one-of any-of many-of
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
; TODO?
; (define retval (rules))
; (expect 'eof) ;; just to make sure we parsed everything...
; retval

(define (expect token-type)
  (match (get-cur-tokens)
    [(list-rest (list type value) rest)
     #:when (eq? type token-type)
     (set-cur-tokens! rest)
     (list type value) #| pls gief as pattern ;( |#]
    [else (raise (exn:parser-error
                  (string-append "unable to match token: " (symbol->string token-type))
                  (current-continuation-marks)))]))

; thunking `maybe`
(define-syntax-rule (maybe rule)
  (maybe-impl (lambda () rule)))

(define (maybe-impl rule)
  (let ([orig-tokens (get-cur-tokens)])
    (with-handlers ([exn:parser-error?
                     (lambda (e)
                       (set-cur-tokens! orig-tokens)
                       #f)])
      (rule))))

; thunking `one-of`
(define-syntax-rule (one-of rule ...)
  (one-of-impl (lambda () rule) ...))

(define (one-of-impl . rules)
  (let loop ([rules rules])
    (match rules
      [(list-rest rule rest)
       (aif (maybe (rule))
            it
            (loop rest))]
      [else (raise
             (exn:parser-error
              "unable to parse one-of cases"
              (current-continuation-marks)))])))

; thunking `any-of`
(define-syntax-rule (any-of rule)
  (any-of-impl (lambda () rule)))

(define (any-of-impl rule)
  (awhile/list (maybe (rule))
               it))

; thunking `many-of`
(define-syntax-rule (many-of rule)
  (many-of-impl (lambda () rule)))

(define (many-of-impl rule)
  (cons (rule) (any-of-impl rule)))
