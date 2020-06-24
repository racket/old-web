#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "DrScheme Jr")

(define hidden? #t)

(define blurb
  @`{DrScheme Jr was a console version of DrScheme.})

(define tag 'drschemejr)
(define download-pages
  (make-download-pages tag title "" "Old Versions"))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{DrScheme Jr was a console version of DrScheme.  It is no longer
       supported, use @(link-to 'plt) instead}))

(begin-page (download-pages 'path+title)
  (define (run) (download-pages 'run panel)))
