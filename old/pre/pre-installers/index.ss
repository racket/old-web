#reader"../../common/html-script.ss"

(import-from "../" content-hole version-hole)

(define title "Pre-Installers")

(define (run)
  (write-tall-page title #:search 'source
    @p{This directory contains distribution packages in tgz format.  They are
       later converted to the actual platform-specific
       @a[href: (url "../installers/")]{installers}.}
    @hr{}
    content-hole
    @hr{}
    version-hole))
