#reader"../../common/html-script.ss"

;; used to reference this page
(define title "Bug Report Query")
(define blurb @`{Search for a bug report or check the status of of a report.})

;; No need for this redirection (it will not work with parameters):
;; (write-redirect-page (url "gnatsweb.pl"))
;; This is much better
(define (gnatsweb-page-config)
  @write-raw*[".htaccess"]{
    DirectoryIndex gnatsweb.pl
    AddHandler cgi-script .pl
    Options ExecCGI})

(define (run)
  (gnatsweb-page-config)
  (writing ""))
