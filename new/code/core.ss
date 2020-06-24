;; XML-like objects with rendering

#lang scheme/base

(require "utils.ss" scribble/text)
(provide (all-from-out scribble/text)
         ;; provide a `text' alias
         (rename-out [begin/text text]))

;; ----------------------------------------------------------------------------
;; An output that handles html quoting, customizable

(define (write-string/html-quote str p [start 0] [end (string-length str)])
  (let loop ([start start])
    (when (< start end)
      (let ([m (regexp-match-positions #rx"[&<>\"]" str start end p)])
        (when m
          (write-string (case (string-ref str (caar m))
                          [(#\&) "&amp;"]
                          [(#\<) "&lt;"]
                          [(#\>) "&gt;"]
                          [(#\") "&quot;"])
                        p)
          (loop (cdar m)))))))

(define/provide html-writer (make-parameter write-string/html-quote))

(define/provide (output-html content [p (current-output-port)])
  (output (disable-prefix (with-writer (html-writer) content)) p))

;; ----------------------------------------------------------------------------
;; XML-like structs: elements, literals, entities

(define-struct element (tag attrs body [cache #:auto #:mutable])
  #:transparent #:omit-define-syntaxes #:auto-value #f
  #:property prop:procedure
  (lambda (e)
    (unless (element-cache e) (set-element-cache! e (element->output e)))
    (element-cache e)))
(define/provide (element tag . args)
  (let-values ([(attrs body) (attributes+body args)])
    (make-element tag attrs body)))
(provide make-element)

(define (element->output e)
  (let ([tag   (element-tag   e)]
        [attrs (element-attrs e)]
        [body  (element-body  e)])
    (define a
      (map (lambda (attr)
             (let ([name (car attr)] [val (cdr attr)])
               (cond [(not val) #f]
                     ;; #t means just mention the attribute
                     [(eq? #t val) (with-writer #f (list " " name))]
                     [else (list (with-writer #f (list " " name "=\""))
                                 val
                                 (with-writer #f "\""))])))
           attrs))
    ;; null body means a lone tag, tags that should always have a closer will
    ;; have a '(#f) as their body (see below)
    (list (with-writer #f "<" tag)
          a
          (if (null? body)
            (with-writer #f " />")
            (list (with-writer #f ">")
                  body
                  (with-writer #f "</" tag ">"))))))

;; similar to element, but will always have a closing tag instead of using the
;; short syntax (see also `element->output' above)
(define/provide (element/not-empty tag . args)
  (let-values ([(attrs body) (attributes+body args)])
    (make-element tag attrs (if (null? body) '(#f) body))))

;; literal struct for things that are not escaped
(define/provide (literal . contents) (with-writer #f contents))

;; entities are implemented as literals
(define/provide (entity x) (literal "&" (and (number? x) "#") x ";"))

;; ----------------------------------------------------------------------------
;; Literals

;; comments and cdata
(define/provide (comment #:newlines? [newlines? #f] . body)
  (let ([newline (and newlines? "\n")])
    (literal "<!--" newline body newline "-->")))
(define/provide (cdata #:newlines? [newlines? #t] #:line-prefix [pfx #f]
                       . body)
  (let ([newline (and newlines? "\n")])
    (literal pfx "<![CDATA[" newline body newline pfx "]]>")))

;; ----------------------------------------------------------------------------
;; Template definition forms

(provide define/provide-elements/empty
         define/provide-elements/not-empty
         define/provide-entities)
(define-syntax-rule (define/provide-elements/empty tag ...)
  (begin (define/provide (tag . args) (apply element 'tag args)) ...))
(define-syntax-rule (define/provide-elements/not-empty tag ...)
  (begin (define/provide (tag . args) (apply element/not-empty 'tag args)) ...))
(define-syntax-rule (define/provide-entities ent ...)
  (begin (define/provide ent ; use bytes-append to make it a little faster
           (literal (string-append "&" (->string 'ent) ";")))
         ...))
