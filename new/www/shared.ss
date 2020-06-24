#lang at-exp s-exp "../code/main.ss"

(require "../common/main.ss" (for-syntax scheme/base))

(provide (all-from-out "../code/main.ss")
         (except-out (all-from-out "../common/main.ss") page)
         (rename-out [page* page]))

(define resources (make-page-resources))

(define-syntax (page* stx)
  (syntax-case stx ()
    [(_ x ...)
     (syntax-property
      #`(page #:resources resources x ...)
      'inferred-name
      (or (inferred-name 'iframe-page stx)
          (raise-syntax-error 'page "need a named context" stx)))]))
