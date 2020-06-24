#reader"../common/html-script.ss"

(import-from "/download/bundle-information.ss"
             make-download-pages plt-version plt-stable-version tag->version)
(import-from "/packages/" packages hidden-packages)

(define title "Download PLT Scheme")

(define blurb
  @`{DrScheme is a graphical, interactive programming environment.  In addition
     to editing and interactive execution facilities, DrScheme also provides
     various student-friendly features, integrated library support, and
     sophisticated analysis tools for advanced programmers.})

(define download-blurb
  @`{The PLT Scheme graphical programming environment.})

(define sys-req
  @system-requirements{
    @windows-versions, @osx-versions, or Unix running the X Window System.  The
    latest version of DrScheme is useful with at least 256MB of RAM in your
    computer, and installing requires roughly 60MB of disk space.})

(define tag 'plt)
(define download-pages
  (make-download-pages tag title sys-req "Download PLT Scheme" "/download"))

(import-from "/www/" panel)

(define (run) (download-pages 'run panel))

(define (split-packages packages)
  (define (packages-get id)
    (map (lambda (p) (get-page-binding p id #f)) packages))
  (let loop ([packages  packages]
             [tags      (packages-get 'tag)]
             [downloads (packages-get 'download-pages)]
             [front     '()]
             [other     '()])
    (cond [(null? packages) (values (reverse front) (reverse other))]
          [(and (not (car tags)) (not (car downloads)))
           (loop (cdr packages) (cdr tags) (cdr downloads) front other)]
          [(not (car tags))
           (error 'download-packages
                  "found package with `download-pages' but no `tag': ~e"
                  (car packages))]
          [(not (car downloads))
           (error 'download-packages
                  "found package with tag but no `download-pages': ~e"
                  (car packages))]
          [(get-page-binding (car packages) 'download-blurb #f)
           => (lambda (b) ; download-blurb => displayed on the front-page
                (if (equal? plt-version (tag->version (car tags)))
                  (loop (cdr packages) (cdr tags) (cdr downloads)
                        (cons (cons ((car downloads) 'link) b) front)
                        other)
                  (error 'download-packages
                         "bad version for `~s'; on front but not updated: ~s"
                         (car packages) (tag->version (car tags)))))]
          [else (loop (cdr packages) (cdr tags) (cdr downloads)
                      front
                      (cons (list (link-to (car packages))
                                  (tag->version (car tags))
                                  ((car downloads) 'url))
                            other))])))

(define-values (front-packages other-packages) (split-packages packages))

(define old-packages
  (let-values ([(front other) (split-packages hidden-packages)])
    (if (null? front)
      other
      (error 'download-packages ; download-blurb => front-page
             "found hidden packages with a download-blurb: ~e" front))))

(define (front-entries)
  (let ([entry (lambda (e) `((,(car e)) ,(cdr e)))])
    `(,@(entry (car front-packages))
      #f
      ,@(mappend entry (cdr front-packages))
      (,(link-to "other.html"))
      ("Other packages (mostly old) available from this site.")
      (,(link-to 'planet))
      ,planet-desc
      #f
      (,(link-to 'pre-release-installers))
      ("Pre-release software is built nightly from our actively developed"
       " sources.")
      ;; (,(link-to "chronology/"))
      ;; ("Chronology of past PLT software versions.")
      )))

#|
(define (run)
  (write-panel-page panel (PLT title) #:navkey 'download
    ;; @p{The current version of PLT Scheme is @b{@plt-version}.
    ;;    @(if (not (equal? plt-stable-version plt-version))
    ;;       @splice{This is an @em{alpha version} @mdash the current
    ;;               stable version is @b{@plt-stable-version}.}
    ;;       @splice{})}
    (apply panel-menu (front-entries))))
|#

(void
 (begin-page "other.html"
   (define title "Other PLT Downloads")
   (define (run)
     (define --- @tr{@th[colspan: 3 align: 'left]{@hr[size: 1]}})
     (define (package-rows packages)
       (apply splice
              (map (lambda (p)
                     @tr{@td[align: 'center]{@(car p)}
                     @td[align: 'center]{@(cadr p)}
                     @td[align: 'center]{@a[href: (caddr p)]{download}}})
                   packages)))
     (write-tall-page title #:navkey 'download
       @p{The following PLT packages include software that is no longer
          maintained.}
       @p{Download a version that matches your installed DrScheme version
          (different versions will usually not work).
          Follow a package's "Download" link to see list of available versions
          for the package.}
       @table[align: 'center border: 0 cellpadding: 3 cellspacing: 0]{
         @tr{@th[align: 'center]{@small{software}}
             @th[align: 'center]{@small{@nbsp latest version @nbsp}}
             @th[align: 'center]{@small{download page}}}
         @---
         @(package-rows other-packages)
         @---
         @tr{@th[colspan: 3 align: 'left]{@i{@small{ancient packages}}}}
         @(package-rows old-packages)
         @---}))))
