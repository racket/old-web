#reader"../common/html-script.ss"

(define title         "Software")
(define sitemap-title "Packages")
(define link-title    "Other PLT Software")

(define (dl* t . ds) (dl (dt t) (apply dd ds)))

(define packages-and-blurbs
  (list "drscheme/" "mred/" "mzscheme/"
        @dl*[(link-to 'planet)]{
          The PLaneT repository includes a wide variety of user-contributed
          packages for PLT Scheme.}
        @section{Applications} ;; ---------------------------------------------
        "slideshow/" "mzc/"
        @section{Redistributable Dynamic Libraries} ;; ------------------------
        "dynamic-libraries/"
        @section{Other Add-Ons} ;; --------------------------------------------
        "profj/" "mysterx/" "mzcom/" "srpersist/"
        @dl*["The Stepper"]{
          The Stepper presents the evaluation of Scheme programs through an
          algebraic reduction semantics.  The Stepper is included with
          @(link-to 'plt).}
        @dl*["Check Syntax"]{
          The syntax checker identifies syntax errors in programs, and provides
          overlay arrows that demonstrate the binding structure of the program.
          Check Syntax is included with @(link-to 'plt).}
        "mrflow/" "openssl/"))

(define packages (map absolute-path (filter string? packages-and-blurbs)))

(define hidden-packages
  (parameterize ([current-directory (this-expression-source-directory)])
    (let* ([sort (lambda (l) (sort l string<?))]
           [dirs (filter directory-exists? (dir))]
           [hidden (filter (lambda (d)
                             (get-page-binding (concat d "/") 'hidden? #f))
                           dirs)]
           [dirs (sort (filter (lambda (d) (not (member d hidden))) dirs))]
           [packages (sort (map (lambda (x) (regexp-replace #rx"/$" x ""))
                                (filter string? packages-and-blurbs)))])
      (unless (equal? dirs packages)
        (error 'packages "package dirs don't match package list in ~a: ~e ~e"
               this-html-name dirs packages))
      (map (lambda (p) (absolute-path (concat p "/"))) hidden))))

(define (run)
  (define (do-line x)
    (cond [(not (string? x)) x]
          [(regexp-match #rx"/" x)
           (apply dl* (link-to x) (get-page-binding x 'blurb))]
          [else (error 'packages "internal error")]))
  (apply write-tall-page* this-html-name (PLT: title)
    (map do-line packages-and-blurbs)))
