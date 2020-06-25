#lang scheme/base

(require "www/main.ss")

(provide build)
(define (build)
  (run))

(module* main #f
  (build))
