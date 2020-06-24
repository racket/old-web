#reader"../../common/html-script.ss"

(define (run)
  (unless (testing?)
    @write-raw*[".htaccess"]{
      Satisfy any
      Allow from all
      Options +ExecCGI
      AddHandler cgi-script .cgi}))
