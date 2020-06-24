#lang at-exp scheme/base
(require (for-syntax scheme/base))

(require "conf.ss" "paths.ss" "begin-page.ss" "utils.ss"
         "../search/search-box.ss" xml)

(define current-url (make-parameter #f))

;; This will define a writer syntax for a content generating procedure
;;   (writer x ...)
;; will use the procedure with `x ...' to generate the content, and then use
;; the value of `this-html-name' from the source syntax which is always bound
;; to the expected output path.  Also define a `writer*' procedure that expects
;; an explicit output filename.
(define-syntax define-writer-syntax
  (syntax-rules ()
    [(_ writer writer* content-generator)
     (begin
       (provide writer writer*)
       (define-syntax (writer stx)
         (define (id sym) (datum->syntax stx sym stx))
         (syntax-case stx ()
           [(_ arg0 arg (... ...))
            (with-syntax ([this-web-dir   (id 'this-web-dir)]
                          [this-html-name (id 'this-html-name)])
              #'(parameterize
                    ([current-url
                      (url (concat (or this-web-dir (current-web-dir))
                                   "/" this-html-name))])
                  (write-string-to-file
                   this-html-name
                   (xexpr->string* (content-generator
                                    arg0 arg (... ...))))))]))
       (define writer*
         (make-keyword-procedure
          (lambda (kws kw-args filename . args)
            (parameterize ([current-url
                            (url (concat (current-web-dir) "/" filename))])
              (write-string-to-file filename
                (xexpr->string*
                 (keyword-apply content-generator kws kw-args args))))))))]))

;; bypasses encoding with &amp; etc; or spit out xhtml header
(define (xexpr->string* x)
  (if (string? x)
    x
    (string-append
     "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\""
     " \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
     (xexpr->string x))))

;; ----------------------------------------------------------------------------

(define-writer-syntax write-xexpr write-xexpr* values)

(define-writer-syntax write-raw   write-raw*   concat)

;; ----------------------------------------------------------------------------

(define-writer-syntax write-redirect-page write-redirect-page* redirect-page)

(define (redirect-page url)
  `(html ()
     (head ()
       (meta ([http-equiv "refresh"] [content ,(concat "0;URL=" url)])))
     (body ()
       "Please go " (a ([href ,url]) "here") ".")))

;; ----------------------------------------------------------------------------

(define-writer-syntax write-page write-page* page)
(provide page)

(define obsolete
  (let ()
    (define (obstext . xs)
      @`div[([class "obsolete"] ,@xs)]{
         @span[([class "obsother"])]{
           See the @a[([href "http://racket-lang.org"])]{Racket site} for
           up-to-date information},
         because PLT Scheme is now Racket.
         (@a[([href "http://racket-lang.org/new-name.html"])]{Why?})
         This page is for compatiblity and historical reference only.})
    `(,(obstext '[style "visibility: hidden;"] '[id "obs0"])
      @div[([class "obsdimmer"] [id "obs1"])]{@nbsp}
      @div[([class "obsdimmertable"] [id "obs2"])]{
        @table[([align "center"] [valign "center"]
                [width "100%"] [height "100%"])]{
          @tr{@td[([align "center"] [valign "center"])]{
                @div[([class "obsdimmertext"])]{
                  PLT Scheme is now Racket
                  @br{}
                  @,obstext[]
                  @div[([class "obsdimmerclose"])]{
                    @a[([href "#"]
                        [onmousedown
                         @,string-append{
                           getElementById('obs0').style.visibility='visible';@;
                           getElementById('obs1').style.display='none';@;
                           getElementById('obs2').style.display='none';@;
                         }])]{
                      [close]}}}}}}})))

(define (page title #:head-stuff       [head-stuff '()]
                    #:extra-body-attrs [extra-body-attrs '()]
                    #:navkey           [navkey #f]
                    . content)
  `(html ([xmlns "http://www.w3.org/1999/xhtml"])
     (head ()
       (title () ,title)
       (meta ([name "generator"] [content "PLT Scheme"]))
       (meta ([http-equiv "Content-Type"]
              [content "text/html; charset=utf-8"]))
       (link ([rel "stylesheet"] [type "text/css"]
              [href "http://plt-scheme.org/plt.css"]
              [title "default"]))
       ,@(icon-link-headers)
       ,@head-stuff)
     (body (,@extra-body-attrs)
       (div ([class "navbar"])
         (div ([class "content"])
           (table ([border "0"] [cellspacing "0"] [cellpadding "0"])
             (tr (td ([rowspan "2"])
                   (img ([src "http://plt-scheme.org/logo.png"]
                         [alt "[logo]"]
                         [style "vertical-align: middle; margin: 0em 0.25em 0em 0em; border: 0;"])))
                (td (div ([class "obstitle"])
                      (span ([class "navtitle"]) "PLT Scheme")
                      ,@obsolete))
                 (td ([class "helpiconcell"])
                     (span ([class "helpicon"])
                           (a ([href "http://plt-scheme.org/help.html"])
                             "Need Help?"))))
             (tr (td ([colspan "2"])
                     ,@(map (lambda (nav)
                              `(span ([class "navitem"])
                                 (span ([class
                                         ,(if (eq? navkey (navbar-ele-key nav))
                                            "navcurlink"
                                            "navlink")])
                                   ,(navbar-ele-link nav))))
                            navbar-links)
                     (span ([class "navitem"]) nbsp))))))
       ,@content
       ,@body-footer)))

;; ----------------------------------------------------------------------------

(define-writer-syntax write-tall-page write-tall-page* tall-page)
(provide tall-page)

;; the body arguments are xexprs, with `section' xexprs marking sections
(define (tall-page title
                   #:head-stuff       [head-stuff '()]
                   #:extra-body-attrs [extra-body-attrs '()]
                   #:wide?            [wide? #f]
                   #:search           [search 'plt]
                   #:navkey           [navkey #f]
                   . content)
  (define (section header)
    `(table ([width "100%"] [cellspacing "0"] [border "0"] [cellpadding "0"])
       (tr (td ([style "font-size: 125%; color: #fed; background-color: #080;"])
             ,@header))))
  (define (do-section xexpr)
    (cond [(not (and (pair? xexpr) (eq? 'section (car xexpr)))) xexpr]
          [(or (null? (cdr xexpr))
               (and (pair? (cadr xexpr)) (not (symbol? (caadr xexpr)))))
           (error 'tall-page "malformed section element: ~e" xexpr)]
          [else (section ((if (null? (cadr xexpr)) cddr cdr) xexpr))]))
  (page title #:head-stuff head-stuff #:extra-body-attrs extra-body-attrs
              #:navkey navkey
    ;; !!! (search-box search)
    `(div (,@(if wide? '() '([class "content"])))
       ,@(map do-section content))))

;; ----------------------------------------------------------------------------

(define-writer-syntax write-panel-page write-panel-page* panel-page)
(provide panel-page)

(define-struct panel (title body))
(provide (rename-out [make-panel* make-panel]))
(define (do-panel-item item)
  ;; force thunks, make links absolute
  (let ([item (if (procedure? item) (item) item)])
    (cond [(string? item) (absolute-path item)]
          [(and (pair? item) (string? item))
           (cons (absolute-path (car item)) (cdr item))]
          [else item])))
(define (make-panel* title . body)
  (make-panel title (map do-panel-item body)))

(define (panel-page panel title
                    #:head-stuff [head-stuff '()]
                    #:search     [search 'plt]
                    #:navkey     [navkey #f]
                    #:fake-url   [fake-url #f] ; to make a link appear as text
                    . content)
  (define main? (equal? title (panel-title panel)))
  (define current (or fake-url (current-url)))
  (define (item x [big? #f])
    (let* ([x (cond [(and (pair? x) (string? (car x)))
                     (let ([url (url (car x))])
                       (if (equal? url current)
                         `(span () ,@(cdr x))
                         `(a ([href ,url]) ,@(cdr x))))]
                    [(not (string? x)) x]
                    [(equal? (url x) current)
                     (get-page-binding x '(link-title title))]
                    [else (link-to x)])]
           [x (if big? `(big () (big () (b () ,x))) x)])
      `(tr () (td ([align "center"]) ,x))))
  ;; !!! (search-box search)
  (page (if main? title (concat (panel-title panel) ": " title))
        #:head-stuff head-stuff #:navkey navkey
    `(div ([class "content"])
       ,@(if main? `() `((h3 () ,title)))
       ,@content)))

;; ----------------------------------------------------------------------------

(define* (panel-menu . elems)
  `(table ([border "0"] [cellpadding "3"] [cellspacing "0"] [width "100%"])
     ,@(let loop ([elems (cons #f elems)])
         (cond
           [(null? elems) null]
           [(not (car elems))
            (cons `(tr (td ([colspan "2"]) (font ([size "-2"]) nbsp)))
                  (loop (cdr elems)))]
           [(null? (cdr elems)) (error 'panel-menu "uneven arguments")]
           [else (list* `(tr () (td ([colspan "2"]) ,@(car elems)))
                        `(tr () (td () nbsp nbsp nbsp nbsp)
                                (td () (small () ,@(cadr elems))))
                        `(tr ([height "4"]) (td ([colspan "2"])))
                        (loop (cddr elems)))]))))

(define icon-link-headers
  ;; should be initialized after build sets the directories
  (let ([links #f])
    (lambda ()
      (unless links
        (let ([ref (url page-icon)])
          (set! links `((link ([rel "icon"] [href ,ref] [type "image/ico"]))
                        (link ([rel "shortcut icon"] [href ,ref]))))))
      links)))

;; ----------------------------------------------------------------------------

;; utility to include text verbatim
(define* literal
  (let ([loc (make-location 0 0 0)])
    (lambda strings (make-cdata loc loc (apply string-append strings)))))
