#lang at-exp s-exp "../code/main.ss"

(require (for-syntax scheme/base))

(provide in-here)
(define-syntax (in-here stx)
  (syntax-case stx ()
    [(_ path paths ...)
     (let ([src (let-values ([(dir name dir?)
                              (split-path (syntax-source stx))])
                  dir)])
       #`(build-path '#,src path paths ...))]))

(define/provide (copyfile source target [referrer values])
  (resource target (lambda (file) (copy-file source file)) referrer))
