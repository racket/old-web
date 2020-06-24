#lang at-exp s-exp "../code/main.ss"
(require "../code/html.ss")

(require (for-syntax scheme/base syntax/name))

;; a link that is displayed as itself
(define/provide (selflink url)
  (tt (a href: url url)))

;; list of a header paragraphs and sub paragraphs (don't use `p' since
;; it looks like they should not be nested)
(define/provide (parlist first . rest)
  (list (div class: 'parlisttitle first)
        (map (lambda (p) (div class: 'parlistitem p)) rest)))

(provide set-navbar!)
(define navbar-links (box #f))
(define-syntax-rule (set-navbar! page ...)
  (set-box! navbar-links (delay (list page ...))))

(provide set-navbar-help!)
(define navbar-help (box #f))
(define-syntax-rule (set-navbar-help! page)
  (set-box! navbar-help (delay page)))

(provide (for-syntax inferred-name))
(define-for-syntax (inferred-name who stx)
  (or (syntax-property stx 'inferred-name)
      (syntax-local-name)
      ;; (raise-syntax-error who "no inferred name, use #:id")
      ))

(provide page plain)
(define-for-syntax (process-contents who layouter stx xs)
  (let loop ([xs xs] [kws '()] [id? #f])
    (syntax-case xs ()
      [(k v . xs) (keyword? (syntax-e #'k))
       (loop #'xs (list* #'v #'k kws) (or id? (eq? '#:id (syntax-e #'k))))]
      [_ (with-syntax
             ([layouter layouter]
              [(x ...) (reverse kws)]
              [(id ...) (if id? '() (list '#:id `',(inferred-name who stx)))]
              [body #`(lambda () (text #,@xs))]) ; delay body, allow defns
           #'(layouter id ... x ... body))])))
(define-syntax (page stx)
  (syntax-case stx ()
    [(_ . xs) (process-contents 'page #'page* stx #'xs)]))
(define-syntax (plain stx)
  (syntax-case stx ()
    [(_ . xs) (process-contents 'plain #'plain* stx #'xs)]))

;; for plain text files
(define (plain* #:id [id #f] #:suffix [suffix #f] #:dir [dir #f]
                #:file
                [file (if (not (and id suffix))
                        (error 'plain
                               "missing `#:file', or `#:id' and `#:suffix'")
                        (let ([f (format "~a.~a" (force id) suffix)])
                          (if dir (string-append dir "/" f) f)))]
                #:referrer
                [referrer (lambda (url)
                            (error 'plain "no referrer for ~e" file))]
                #:newline [newline? #t]
                . content)
  (plain-output-resource file (list content (and newline? "\n")) referrer))

(define obsolete
  (let ()
    (define why @a[href: "http://racket-lang.org/new-name.html"]{Why?})
    (define racket-site @a[href: "http://racket-lang.org"]{Racket site})
    (define short-obsolete
      ;; short obsolete text for the top
      @div[class: 'obsolete style: "visibility: hidden;" id: 'obs0]{
        @span[class: 'obsother]{
          See the @racket-site for up-to-date information},
        because PLT Scheme is now Racket.  (@why)
        This page is for compatiblity and historical reference only.})
    (define long-obsolete
      ;; longer version for the popup overlay
      @div[class: 'obsolete]{
        @p{With the release of version 5.0, PLT Scheme was renamed to Racket.
           (@why)}
        @p{PLT will continue to maintain and grow Racket as it did for PLT
           Scheme for 15 years.  Our commitment to this product hasn't changed
           and we will continue to work with all of our users on the usefulness
           of our programming language and IDE.}
        @p{This @strong{web page} is maintained for historical reasons only.
           For all future releases, please visit the @|racket-site|.}})
    (list
     @short-obsolete
     @div[class: 'obsdimmer id: 'obs1]{@nbsp}
     @div[class: 'obsdimmertable id: 'obs2]{
       @table[align: 'center valign: 'center width: "100%" height: "100%"]{
         @tr{@td[width: "45%"]{@nbsp}
             @td[align: 'center valign: 'center]{
               @div[class: 'obsdimmertext]{
                 PLT Scheme is now Racket
                 @br
                 @long-obsolete
                 @div[class: 'obsdimmerclose]{
                   @a[href: "#"
                      onmousedown:
                      '("getElementById('obs0').style.visibility='visible';"
                        "getElementById('obs1').style.display='none';"
                        "getElementById('obs2').style.display='none';")]{
                     [close]}}}}
             @td[width: "45%"]{@nbsp}}}})))

;; page layout function
(define (page* #:id [id #f]
               #:dir [dir #f]
               #:file [file (if (not id)
                              (error 'page "missing `#:file' or `#:id'")
                              (let ([f (format "~a.html" (force id))])
                                (if dir (string-append dir "/" f) f)))]
               #:title [label (if id
                                (let* ([id (->string (force id))]
                                       [id (regexp-replace #rx"^.*/" id "")]
                                       [id (regexp-replace #rx"-" id " ")])
                                  (string-titlecase id))
                                (error 'page "missing `#:file' or `#:title'"))]
               #:full-width [full-width #f]
               #:extra-body-attrs [body-attrs #f]
               #:offer-help? [offer-help? #t]
               #:resources resources ; see below
               content)
  (define-values [style logo icon] (apply values resources))
  (define (page)
    (define head*
      (list (title "PLT Scheme")
            (meta name: "generator" content: "PLT Scheme")
            (meta http-equiv: "Content-Type"
                  content: "text/html; charset=utf-8")
            (link rel: "icon" href: icon type: "image/ico")
            (link rel: "shortcut icon" href: icon)
            style))
    (define navbar*
      (div class: 'navbar
        (div class: 'content
          (table border: 0 cellspacing: 0 cellpadding: 0
            (tr (td rowspan: 2
                  (img src: logo alt: "[logo]"
                       style: '("vertical-align: middle; "
                                "margin: 0em 0.25em 0em 0em; border: 0;")))
                (td (div class: 'obstitle
                      (span class: 'navtitle "PLT Scheme")
                      obsolete))
                (td class: 'helpiconcell
                    (span class: 'helpicon
                          (if offer-help?
                            (force (unbox navbar-help))
                            nbsp))))
            (tr (td colspan: 2
                    (map (lambda (nav)
                           (span class: 'navitem
                             (span class: (if (eq? this nav)
                                            'navcurlink 'navlink)
                               nav)))
                         (force (unbox navbar-links)))
                    (span class: 'navitem nbsp)))))))
    (define content* (if full-width content (div class: 'content content)))
    @xhtml{@head{@head*}
           @(if body-attrs
              (apply body `(,@body-attrs ,navbar* ,content*))
              (body navbar* content*))})
  (define this
    (html-output-resource file page (lambda (url) (a href: url label))))
  this)

;; iframe pages to swallow all kinds of stuff into our page style
(provide iframe-page plt-iframe-page)
(define (iframe* url)
  (list (iframe src: url id: "the_frame" width: "1400" height: "0"
                align: 'middle frameborder: 0 scrolling: 'auto
                marginheight: 0 marginwidth: 0)
        @script/inline[type: "text/javascript"]{
          var the_frame = document.getElementById("the_frame");
          function ResizeIFrame() {
            var n;
            n = document.documentElement.clientHeight
                - the_frame.offsetTop - 10; // for bottom spacing below frame
            the_frame.style.height = n + "px";
            n = document.documentElement.clientWidth
                - the_frame.offsetLeft - 10; // for right spacing next to frame
            the_frame.style.width = n + "px";
          }
          the_frame.onload = ResizeIFrame;
          window.onresize = ResizeIFrame;
        }))
(define-syntax (iframe-page stx)
  (syntax-case stx ()
    [(iframe-page url x ...)
     (syntax-property #'(page #:full-width #t x ...
                              (lambda () (iframe* url)))
                      'inferred-name (inferred-name 'iframe-page stx))]))
(define-syntax (plt-iframe-page stx)
  (syntax-case stx ()
    [(_ x ...)
     (let ([name (or (inferred-name 'iframe-page stx)
                     (raise-syntax-error
                      'plt-iframe-page "need a named context" stx))])
       (syntax-property
        #`(page #:full-width #t x ...
                (lambda () (iframe* `("http://" #,name ".plt-scheme.org"))))
        'inferred-name name))]))
