#lang scheme/base

(provide (all-defined-out))

;; ratio must be rational, must make ints when multiplied by heights
(define image-ratio   4/3)
(define image-height  600)
(define thumb-height   96) ; good if this is a multiplication of min-height
(define min-height     24)
(define zoom-radius     3) ; measured in thumb heights
(define horiz-radius    1) ; measured in thumb widths
(define thumb-pad    1/16) ; thumb portion that is used for padding

(define bubble-delay-in   75)
(define bubble-delay-out 500)
(define bubble-bcolor    "ff8080") ;e09090
(define bubble-color     "ffc0c0") ;ffd0d0

(define blurb-color      "ffd0d0")

(define size-func
  ;; `cos' works best -- no roundoff errors that cause pixel jitter
  "function(x) { return (Math.cos(x*Math.PI)+1)/2; }"
  #| Possible alternatives:
  "function(x) { return 1-x; }"
  "function(x) { x = 1-x*x; return x*x; }"
  "function(x) { x = 1-x*x; return x*x*x*x; }"
  |#)

;; computed things

(define (height->width h)
  (let ([w (* h image-ratio)])
    (unless (integer? w)
      (error 'height->width "non-integer width: ~e*~e = ~e" h image-ratio w))
    w))

(define image-width (height->width image-height))
(define thumb-width (height->width thumb-height))
(define min-width   (height->width min-height))

(require (only-in scheme/math pi))
(define padding
  (inexact->exact
   (round
    (for/fold ([p (/ (- thumb-height min-height) 2)])
              ([i (in-range (sub1 zoom-radius) 0 -1)])
      (+ p (* ;; Scheme code for the size-func
              (/ (+ (cos (* (/ i zoom-radius) pi)) 1) 2)
              (- thumb-height min-height)))))))
