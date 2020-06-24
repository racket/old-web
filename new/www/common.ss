#lang at-exp s-exp "shared.ss"

;; ----------------------------------------------------------------------------
;; documentation links

(define doc-url "http://docs.plt-scheme.org/")

(define-syntax-rule (define-doc-link id desc)
  (define id
    @a[href: `(,doc-url id "/")]{
      @strong{@(string-titlecase (symbol->string 'id))}: @desc}))

(define-doc-link quick @'{An Introduction to PLT Scheme with Pictures})

(define-doc-link more  @'{Systems Programming with PLT Scheme})

(define-doc-link guide @'{PLT Scheme})

(define/provide intros (list quick more guide))

;; ----------------------------------------------------------------------------
;; misc plt links

(define/provide download @a[href: "http://download.plt-scheme.org/"]{Download})
(define/provide docs     @a[href: "http://docs.plt-scheme.org/"]{Documentation})
(define/provide planet   @a[href: "http://planet.plt-scheme.org/"]{PLaneT})
(define/provide blog     @a[href: "http://blog.plt-scheme.org/"]{Blog})

;; ----------------------------------------------------------------------------
;; external links

(define/provide htdp
  @a[href: "http://www.htdp.org/"]{@i{How to Design Programs}})

(define/provide teachscheme
  @a[href: "http://www.teach-scheme.org/"]{TeachScheme!})

(define/provide schematics
  @a[href: "http://schemecookbook.org/"]{Schematics Scheme Cookbook})

(define/provide schemers
  @a[href: "http://schemers.org/"]{@tt{schemers.org}})

(define/provide plai
  @a[href: "http://www.plai.org/"]{
    @i{Programming Languages: Application and Interpretation}})
