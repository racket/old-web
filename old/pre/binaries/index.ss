#reader"../../common/html-script.ss"

(import-from "../" content-hole version-hole)

(define title "Pre-Release Binaries")

(define (run)
  (write-tall-page title #:search 'source
    @p{This directory contains a subdirectory for each supported platform.}
    @hr{}
    content-hole
    @hr{}
    version-hole))
