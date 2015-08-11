#lang racket
(provide lex exn:lexer-error exn:lexer-error?)

(define (make-pattern pattern)
  (regexp (string-append "^(" pattern ")")))

(define (lex patterns code)
  (let loop ([code code] [tokens '()])
    (if (= 0 (string-length code))
        (reverse tokens) ; as the cons is backwards...
        (if (eq? #\space (string-ref code 0))
            (loop (string-trim code) tokens)
            (match (for/first ([pattern patterns]
                    #:when (regexp-match? (make-pattern (car pattern)) code))
                    pattern)
              [(list regxp type)
               (match-let ([(list _ m) (regexp-match (make-pattern regxp) code)])
                 (loop (substring code (string-length m))
                       (cons (list type m) tokens)))]
              [#f (raise
                   (exn:lexer-error
                    (string-append
                     "Unable to parse code: "
                     (substring code 0 (min 15 (string-length code))))
                    (current-continuation-marks)))])))))

(struct exn:lexer-error exn ())
