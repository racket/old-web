#reader"../../common/html-script.ss"

(import-from "../" content-hole version-hole)

(define title "Pre-Release Documentation")

(define (run)
  (write-tall-page title #:search 'docs
    @p{This directory contains documentation files in all forms, compiled from
       the current sources.}
    @hr{}
    content-hole
    @hr{}
    version-hole))
