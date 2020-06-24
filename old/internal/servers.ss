#reader"../common/html-script.ss"

(define title "PLT Internet Servers")

(define headers
  '("Server" "Type" "Server Contact" "Host Machine"
    "Host Contact" "Content Contact" "Notes"))

(define data ; one value per header, notes is optional
  `((schemers:    web     shriram brown-cs:    brown-adm shriram)
    (srfi:        web     shriram de-rotkohl:  sperber   srfi-editors)
    (plt:         web     shriram plt:         matthew   shriram
                  "Address in flux.utah.edu, but no actual name there")
    (htus:        web     shriram plt:         shriram   shriram)
    (drscheme:    web     shriram plt:         shriram   shriram
                  "Redirects to DrScheme software page")
    (ts:          web     shriram plt:         matthew   shriram)
    (htdp:        web     shriram plt:         matthew   shriram)
    (download:    web     eli     champlain:   eli       eli)
    (bugs:        web     eli     champlain:   eli       eli
                  "Runs the GNATS system")
    (svn:         svn     eli     svn:         eli       eli)
    (cvs:         cvs     neu-edu denali:      neu-edu   eli
                  "Remote access requires SSH and CCS login")
    (anoncvs:     anoncvs neu-edu fantastica:  neu-edu   eli)
    (internal:    web     eli     champlain:   eli       eli
                  "PLT internal site")))

(import-from "/download/bundle-information.ss" mirrors)
(define mirrors-data
  (map (lambda (mir)
         (let* ([url (url (cadr mir))]
                [m (or (regexp-match #rx"^([a-z]+)://(.*)$" url)
                       (error 'internal-error "bad mirror data: ~e" mir))]
                [scheme (string->symbol (cadr m))]
                [url    (caddr m)])
           `(,url ,scheme (,(caddr mir) ,(cadddr mir))
             "mirror machine" ("" "") ("" "")
             ("mirror at" (br)
              ,@(if (list? (car mir)) (car mir) (list (car mir)))))))
       mirrors))

(define symbols ; translates symbols in the table above
  '(;; types
    (web "Web") (ftp "FTP") (svn "Subversion") (http "Web")
    (cvs "CVS (deprecated)") (anoncvs "Anonymous CVS (deprecated)")
    ;; sites
    (schemers:    "www.schemers.org")
    (srfi:        "srfi.schemers.org")
    (plt:         "www.plt-scheme.org")
    (htus:        "www.htus.org")
    (drscheme:    "www.drscheme.org")
    (ts:          "www.teach-scheme.org")
    (htdp:        "www.htdp.org")
    (download:    "download.plt-scheme.org")
    (bugs:        "bugs.plt-scheme.org")
    (svn:         "svn.plt-scheme.org")
    (cvs:         "cvs.plt-scheme.org")
    (anoncvs:     "anoncvs.plt-scheme.org")
    (internal:    "internal.plt-scheme.org")
    (champlain:   "champlain.ccs.neu.edu")
    (denali:      "denali.ccs.neu.edu")
    (fantastica:  "fantastica.ccs.neu.edu")
    (brown-cs:    "www.cs.brown.edu")
    (de-rotkohl:  "rotkohl.informatik.uni-tuebingen.de")
    ;; contacts
    (shriram      ("Shriram Krishnamurthi" "sk@cs.brown.edu"))
    (matthew      ("Matthew Flatt" "mflatt@cs.utah.edu"))
    (eli          ("Eli Barzilay" "eli@barzilay.org"))
    (sperber      ("Michael Sperber" "sperber@informatik.uni-tuebingen.de"))
    (crestani     ("Marcus Crestani" "crestani@informatik.uni-tuebingen.de"))
    (neu-edu      ("Northeastern U. Systems" "systems@ccs.neu.edu"))
    (brown-adm    ("Brown U. Systems Staff" "problem@cs.brown.edu"))
    (srfi-editors ("SRFI editors" "srfi-editors@srfi.schemers.org"))))

(define (do-row entry)
  (define (pop . default)
    (let ([x (cond
              [(pair? entry) (begin0 (car entry) (set! entry (cdr entry)))]
              [(pair? default) (car default)]
              [else #f])])
      (cond [(assq x symbols) => cadr] [else x])))
  (let ([server          (pop)]
        [server-type     (pop)]
        [server-contact  (pop)]
        [host            (pop)]
        [host-contact    (pop)]
        [content-contact (pop)]
        [notes           (pop "---")])
    @tr[bgcolor: "#C0C0C0"]{
      @td{@(cond [(string=? server-type "Web")
                  (let ([url (string-append "http://" server)])
                    @a[href: url]{@url})]
                 [(string=? server-type "FTP")
                  (let ([url (string-append "ftp://" server)])
                    @a[href: url]{@url})]
                 [else server])}
      @td{@server-type}
      @td{@(car server-contact) @br{} @(cadr server-contact)}
      @td{@host}
      @td{@(car host-contact) @br{} @(cadr host-contact)}
      @td{@(car content-contact) @br{} @(cadr content-contact)}
      @td{@(if (list? notes) (apply splice notes) notes)}}))

(define (run)
  (write-tall-page title
    (apply table align: 'center style: "font-size:x-small"
           (apply tr (map (lambda (h)
                            @th[align: 'center bgcolor: 'lightgreen]{@h})
                          headers))
           (map do-row (append data mirrors-data)))
    @br{}@hr{}@br{}
    @p{This table is maintained by Eli Barzilay, @tt{eli@"@"barzilay.org}.}))

#|
(define the-mirrors
  `(table (())
     (thead (())
       (tr () ,@(map (lambda (x) `(th () ,x))
                     '("Location" "URL" "Contact" "Technical Contact")))
       ,@(map (lambda (m)
                `(tr ()
                   (td () ,(car m))
                   (td () ,(cadr m))
                   (td () ,(caddr m) (br) ,(cadddr m))
                   (td () ,(if (null? (cddddr m)) nbsp (car (cddddr m))))))
              mirrors))))
|#
