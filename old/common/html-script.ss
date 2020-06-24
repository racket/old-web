#lang scheme/base

(require (prefix-in r: scribble/reader) mzlib/etc)

(define (read-body read-syntax inp)
  (let* ([dir
          (regexp-replace
           #rx"/?$" (path->string (this-expression-source-directory)) "/")]
         [req-file
          (lambda (str) `(file ,(string-append dir str)))]
         [n (object-name inp)]
         [n (cond [(path? n)
                   (let-values ([(base name dir?) (split-path n)])
                     (string->symbol
                      (path->string (path-replace-suffix name #""))))]
                  [(symbol? n) n]
                  [else 'unknown])])
    (let loop ([body '()])
      (let ([expr (read-syntax)])
        (if (eof-object? expr)
          `(module ,n scheme/base
             (require ,(req-file "html-xexprs.ss")
                      ,(req-file "conf.ss")
                      ,(req-file "utils.ss")
                      ,(req-file "paths.ss")
                      ,(req-file "layout.ss")
                      ,(req-file "misc-html.ss")
                      ,(req-file "begin-page.ss")
                      ,(req-file "build.ss")
                      scheme/list scheme/match scheme/promise mzlib/etc)
             (provide (all-defined-out))
             (define this-html-name (concat ',n ".html"))
             (define this-web-dir   (current-web-dir))
             (define this-build-dir (current-directory))
             (define-syntax with-this-context
               (syntax-rules ()
                 [(_ expr ...)
                  (parameterize ([current-web-dir   this-web-dir]
                                 [current-directory this-build-dir])
                    expr ...)]))
             (define sub-pages '())
             ,@(reverse body))
          (loop (cons expr body)))))))

(define (*read inp)
  (read-body (lambda () (r:read inp)) inp))

(define (*read-syntax src inp)
  (read-body (lambda () (r:read-syntax src inp)) inp))

(provide (rename-out [*read read] [*read-syntax read-syntax]))
