#reader"../common/html-script.ss"

(define title "PLT Mail via Gmail")

(define (run)
  (write-redirect-page (url "/internal/mail.html")))
