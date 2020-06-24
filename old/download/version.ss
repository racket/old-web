#reader"../common/html-script.ss"

(import-from "bundle-information.ss" plt-version plt-stable-version)

(define (run)
  (unless (testing?)
    (write-raw* "version"
      (format ";; ~a\n;; ~a\n~s\n"
              "This is for ancient (pre-v4) installations, the real"
              "information is in version.txt."
              `([recent "500"] [stable "500"])))
    (write-raw* "version.txt"
      (format ";; ~a\n;; ~a\n~s\n"
              "This is for old (pre-racket) installations, the real"
              "information is at download.racket-lang.org."
              ;; `([recent ,plt-version] [stable ,plt-stable-version])
              `([recent "5.0"] [stable "5.0"])))))
