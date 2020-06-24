#lang scheme/base

(provide (all-defined-out))

;; Our CSE unique identifier
(define plt-id  "010927490648632664335:4yu6uuqr9ia")
(define form-id    (string-append "searchbox_"plt-id))
(define results-id (string-append "results_"plt-id))

;; Our Ajax key (for www.plt-scheme.org):
(define plt-ajax-key
  (string-append "ABQIAAAAfEJRjYRPh7y8Jhif1MP-xx"
                 "Tlj1YgDwvjP9lkJxsRxT99gbXMRRQeSwmcbfV0lwsDSY2A5zm8UY68MQ"))
