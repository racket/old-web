#lang scheme/base

(require scheme/list scheme/string scheme/promise)
(provide (all-from-out scheme/list scheme/string scheme/promise))

(provide define/provide)
(define-syntax define/provide
  (syntax-rules ()
    [(_ (id . args) . body) (define/provide id (lambda args . body))]
    [(_ id expr) (begin (define id expr) (provide id))]))

(define/provide (thunk? x)
  (and (procedure? x) (procedure-arity-includes? x 0)))

(define/provide (->string x)
  (cond [(string? x) x]
        [(path?   x) (path->string x)]
        [(bytes?  x) (bytes->string/utf-8 x)]
        [(symbol? x) (symbol->string x)]
        [(number? x) (number->string x)]
        [else (error '->string "don't know what to do with ~e" x)]))

;; attributes

(define attribute->symbol
  (let ([t (make-weak-hasheq)])
    (lambda (x)
      (and (symbol? x)
           (hash-ref! t x
             (lambda ()
               (let* ([str (symbol->string x)]
                      [len-1 (sub1 (string-length str))])
                 (and (len-1 . > . 0)
                      (char=? #\: (string-ref str len-1))
                      (string->symbol (substring str 0 len-1))))))))))

(define/provide attribute? attribute->symbol)

(define/provide (attributes+body xs)
  (let loop ([xs xs] [as '()])
    (let ([a (and (pair? xs) (attribute->symbol (car xs)))])
      (cond [(not a) (values (reverse as) xs)]
            [(null? (cdr xs)) (error 'attriubtes+body
                                     "missing attribute value for `~s:'" a)]
            [else (loop (cddr xs) (cons (cons a (cadr xs)) as))]))))
