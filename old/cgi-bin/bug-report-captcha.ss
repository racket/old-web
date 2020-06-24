#reader"../common/html-script.ss"

(import-from "../bugs/" captcha-text)

(define (run)
  (write-raw* "bug-report-captcha" captcha-text))
