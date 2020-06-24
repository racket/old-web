#reader"../common/html-script.ss"

(define title "Site Map")

(import-from "/packages/" packages)

(define sections
  `((("Released Software"
      "/download/"
      "software/"
      ,@(map (lambda (p) (list '> p)) packages)
      planet
      ("Old Contributions" "http://www.cs.utah.edu/plt/develop/")
      "license/"
      (search plt)
      ))
    (("Documentation and Learning"
      docs
      (search docs)
      screenshots
      tour
      htdp
      fixnum
      cookbook
      htus
      (search learn)
      )
     ("Support"
      "maillist/"
      "maillist/espanol.html"
      "/bugs/"
      bug-query
      (search bugs)
      ))
    (("Development"
      pre-release-top
      (> pre-release-installers)
      (> pre-release-docs)
      "/svn/"
      ("Browse Source" "/pre/plt/")
      ;; pre-release-search
      "/download/chronology/"
      schematics
      (search source)
      )
     ("Academics"
      "who/"
      teachscheme!
      "publications.html"
      "techreports/"
      "who/common-plt-app.html"
      (search academic)
      ))))

(require "../search/search-box.ss")
(define (do-section section)
  (define (row* attrs content) `(tr () (td ,attrs (nobr () ,@content))))
  (define (row content) (row* `((style "font-size: 80%;")) content))
  (define indent1 '(nbsp nbsp nbsp nbsp nbsp))
  (define indent2 (append indent1 indent1))
  (cons
   (row* `([style "font-size: 125%; color: #fed; background-color: #080;"])
         `((b () ,(car section) nbsp nbsp)))
   (map
    (lambda (link)
      (row (map (lambda (x)
                  (case x
                    [(>) indent1] [(>>) indent2]
                    [else
                     (cond [(and (pair? x) (eq? 'search (car x)))
                            (apply search-box (cdr x))]
                           [(and (list? x) (= 2 (length x)))
                            `(a ([href ,(url (cadr x))]) ,(car x))]
                           [else
                            (link-to x #:names '(sitemap-title title))])]))
                (cons '> (if (and (pair? link) (memq (car link) '(> >>)))
                           link (list link))))))
    (cdr section))))

(define (run)
  (write-tall-page (PLT: title)
    `(table ((align "center") (border "0") (cellspacing "0") (cellpadding "0"))
       (tr ()
         ,@(map/sep
            (lambda (column)
              `(td ([align "left"] [valign "top"])
                 (table ([border "0"] [cellspacing "0"] [cellpadding "0"])
                   ,@(mappend/sep do-section
                                  `(tr () (td () nbsp nbsp nbsp nbsp))
                                  column))))
            `(td () nbsp nbsp nbsp)
            sections)))))
