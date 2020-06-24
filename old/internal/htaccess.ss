#reader"../common/html-script.ss"

(define (run)
  (unless (testing?)
    @write-raw*[".htaccess"]{
      AuthName "PLT Internal"
        AuthType Basic
        AuthUserFile /etc/httpd/conf/passwd
        Require valid-user}))
