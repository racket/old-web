#lang scheme/base
(require (for-syntax scheme/base))

(provide begin-page)
(define-syntax (begin-page stx)
  (syntax-case stx ()
    [(_ filename expr ...)
     (with-syntax
         ([sub-pages (datum->syntax stx 'sub-pages stx)]
          [this-html-name (datum->syntax stx 'this-html-name stx)]
          [(var ...)
           (let loop ([exprs (syntax->list stx)] [vars '()])
             (if (null? exprs)
               (reverse vars)
               (loop (cdr exprs) (syntax-case (car exprs) (define)
                                   [(define (f . xs) . body) (cons #'f vars)]
                                   [(define var expr) (cons #'var vars)]
                                   [_ vars]))))])
       #'(let ([this-html-name filename])
           ;; (unless (and (string? name) (regexp-match #rx"^[^/]*$" name))
           ;;   (raise-type-error 'begin-page "string-without-slashes" name))
           expr ...
           (set! sub-pages (cons (list this-html-name (cons 'var var) ...)
                                 sub-pages))
           this-html-name
           (void)))]))
