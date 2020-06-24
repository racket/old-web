;; Resources are referrable & renderable objects, mostly html pages

#lang scheme/base

(require "utils.ss" "core.ss")

;; (resource path renderer referrer) creates and returns a new "resource"
;; value.  The arguments are:
;; - `path': the path of the output file, relative to the working directory,
;;   indicating where the file should be put at, also corresponding to the URL
;;   it will be found at.  It must be a `/'-separated relative string, no `..',
;;   `.', or `//', and can end in `/'.
;; - `renderer': a unary function that renders the resource, receiving the path
;;   for the file to be created as an argument.  This path will be different
;;   than the `path', since this function is invoked in the target directory.
;; - `referrer': a function accepting one or more arguments (and possibly
;;   keywords) that produces a value to be used to refer to this resource
;;   (using `a', `img', etc).  The first value that will be passed to this
;;   function will be the actual URL path, which depends on the currently
;;   rendered page path since it is made relative to it.
;; The resulting resource value is actually a rendering function that is
;; similar to the `referrer', except without the first URL argument -- when it
;; is called, it invokes the `referrer' function with the actual (relativized)
;; URL.  Creating a resource registers the `renderer' to be executed when
;; rendering is initiated.  Note that more resources can be created while
;; rendering; they will also be rendered in turn until no more resources are
;; created.

;; utility for keeping a list of renderer thunks
(define-values  [add-renderer get/reset-renderers]
  (let ([l '()] [s (make-semaphore 1)])
    ;; map paths to #t -- used to avoid overwriting files
    (define t (make-hash))
    (define-syntax-rule (S body) (call-with-semaphore s (lambda () body)))
    (values (lambda (path renderer)
              (S (if (hash-ref t path (lambda () (hash-set! t path #t) #f))
                   (error 'resource "path used for two resources: ~e" path)
                   (set! l (cons renderer l)))))
            (lambda () (S (begin0 (reverse l) (set! l '())))))))

;; default file, urls to it will point to its directory instead
(define default-file "index.html")
;; the currently rendered directory as a list
(define rendered-dirpath (make-parameter '()))
;; a utility for relative paths, using both of the above
(define (relativize file tgtdir curdir)
  (let loop ([t tgtdir] [c curdir])
    (if (and (pair? t) (pair? c) (equal? (car t) (car c)))
      (loop (cdr t) (cdr c))
      (let* ([file (if (equal? file default-file) "" file)]
             [r (string-join `(,@(map (lambda (_) "..") c) ,@t ,file) "/")])
        (if (equal? "" r) "." r)))))
#| tests
(andmap (lambda (t)
          (equal? (relativize (car t) (cadr t) (caddr t)) (cadddr t)))
        '(["bleh.txt" () () "bleh.txt"]
          ["bleh.txt" ("x") () "x/bleh.txt"]
          ["bleh.txt" ("x" "y") () "x/y/bleh.txt"]
          ["bleh.txt" () ("x") "../bleh.txt"]
          ["bleh.txt" ("x") ("x") "bleh.txt"]
          ["bleh.txt" ("x" "y") ("x") "y/bleh.txt"]
          ["bleh.txt" () ("x" "y") "../../bleh.txt"]
          ["bleh.txt" ("x") ("x" "y") "../bleh.txt"]
          ["bleh.txt" ("x" "y") ("x" "y") "bleh.txt"]
          ["index.html" () () "."]
          ["index.html" ("x") () "x/"]
          ["index.html" ("x" "y") () "x/y/"]
          ["index.html" () ("x") "../"]
          ["index.html" ("x") ("x") "."]
          ["index.html" ("x" "y") ("x") "y/"]
          ["index.html" () ("x" "y") "../../"]
          ["index.html" ("x") ("x" "y") "../"]
          ["index.html" ("x" "y") ("x" "y") "."]
          ))
|#

;; `#:exists' determines what happens when the render destination exists, it
;; can be one of: #f (do nothing), 'delete-file (delete if a file exists, error
;; if exists as a directory)
(define/provide (resource path renderer referrer
                          #:exists [exists 'delete-file])
  (define (bad reason) (error 'resource "bad path, ~a: ~e" reason path))
  (unless (string? path) (bad "must be a string"))
  (for ([x (in-list '([#rx"^/" "must be a relative name"]
                      [#rx"//" "must not have empty elements"]
                      [#rx"(?:^|/)[.][.]?(?:/|$)"
                          "must not contain `.' or `..'"]))])
    (when (regexp-match? (car x) path) (bad (cadr x))))
  (let ([path (regexp-replace #rx"(?<=^|/)$" path default-file)])
    (define-values (dirpathlist filename)
      (let-values ([(l r) (split-at-right (regexp-split #rx"/" path) 1)])
        (values l (car r))))
    (define (render)
      (let loop ([ps dirpathlist])
        (cond [(null? ps)
               (cond [(not exists)] ; do nothing
                     [(or (file-exists? filename) (link-exists? filename))
                      (delete-file filename)]
                     [(directory-exists? filename)
                      (bad "exists as directory")])
               (parameterize ([rendered-dirpath dirpathlist])
                 (printf "  ~a\n" path)
                 (renderer filename))]
              [else
               (unless (directory-exists? (car ps))
                 (if (or (file-exists? (car ps)) (link-exists? (car ps)))
                   (bad "exists as a file/link")
                   (make-directory (car ps))))
               (parameterize ([current-directory (car ps)]) (loop (cdr ps)))])))
    (define (url) (relativize filename dirpathlist (rendered-dirpath)))
    (add-renderer path render)
    (make-keyword-procedure
     (lambda (kws kvs . args) (keyword-apply referrer kws kvs (url) args))
     (lambda args (apply referrer (url) args)))))

;; convenient wrappers that use `output' and `output-html' to generate files
(define/provide (plain-output-resource path content referrer)
  (resource path
            (lambda (file)
              (call-with-output-file file (lambda (o) (output content o))))
            referrer))
(define/provide (html-output-resource path content referrer)
  (resource path
            (lambda (file)
              (call-with-output-file file
                (lambda (o) (output-html content o))))
            referrer))

;; runs all renderers, and any renderers that might have been added on the way
(define/provide (render-all)
  (printf "Rendering...\n")
  (let loop ()
    (let ([todo (get/reset-renderers)])
      (unless (null? todo)
        (for-each (lambda (r) (r)) todo)
        (loop)))) ; if more were created
  (printf "Done.\n"))
