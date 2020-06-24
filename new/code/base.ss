#lang scheme/base

;; Use `foo:' as self-quoting symbols, to be used for attribute names in
;; elements.  A different option would be to use the usual scheme/base keyword
;; arguments, but that tends to have problems like disallowing repeated uses of
;; the same keyword, sorting the keywords alphabetically, and ambiguity when
;; some keywords are meant to do the usual thing (customize a function) instead
;; of representing an attribute.  It's more convenient to just have a parallel
;; mechanism for this, so scheme/base keywords are still used in the same way,
;; and orthogonal to specifying attributes.

(require (for-syntax scheme/base "utils.ss"))

(provide (except-out (all-from-out scheme/base) #%top)
         (rename-out [top #%top]))

(define-syntax (top stx)
  (syntax-case stx ()
    [(_ . x) (attribute? (syntax-e #'x)) #''x]
    [(_ . x) #'(#%top . x)]))
