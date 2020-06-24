#lang scheme/base

(require "conf.ss" "utils.ss" scheme/path scheme/file mzlib/etc)

(define* build-dir (make-parameter #f))

(define* source-dir
  (normalize-path
   (dirname (path->string (this-expression-source-directory)))))

(define* current-web-dir (make-parameter #f))

;; ============================================================================
;; mappings

(define* top-dirs #f)
(define mappings #f)

;; the argument to `set-mappings!' is a list of source-target mappings:
;; * if the source does not begin with a "/", it specifies a top-level
;;   directory that will be processed when building the pages
;; * if the mapped path is a url, it is used when creating urls through the
;;   `url' function (eg, (url "/www/foo.html"))
;; * otherwise the mapped path is used to map a source path to a web path and
;;   another mapping is attempted -- so it can also map web paths to different
;;   web paths; it is also used before `url' maps to a url.
;; * mappings are tried in order
;; * mappings should be 1:1 for reverse mapping of web-path to source path
(define-struct mapdata (type from to from-re to-re))
(define (set-mappings! new)
  (define (->regexp str)
    (regexp (concat "^(" (regexp-quote str) ")(?:/|$)")))
  (set! top-dirs '())
  (set! mappings
        (map (lambda (m)
               (define (check-path p url?)
                 (unless (and (regexp-match #rx"[^/]$" p)
                              (or (regexp-match #rx"^/" p)
                                  (and url? (url-string? p))))
                   (error 'set-mappings! "bad path: ~e" p)))
               (let ([from (car m)] [to (cadr m)])
                 (when (regexp-match #rx"^[^/]+$" from)
                   (set! top-dirs (cons from top-dirs))
                   (set! from (concat "/" from)))
                 (check-path from #f)
                 (check-path to #t)
                 (make-mapdata (if (url-string? to) 'url 'path) from to
                               (->regexp from) (->regexp to))))
             new))
  (set! top-dirs (reverse top-dirs)))
(set-mappings! default-mappings)

;; simple mappings (for temporary builds) are based on the default mapping
;; where all urls are replaced by a given prefix.
(define* (set-simple-mappings! prefix)
  (unless (url-string? prefix)
    (error 'set-simple-mappings! "bad prefix: ~e" prefix))
  (let ([prefix (regexp-replace #rx"/$" prefix "")])
    (set-mappings!
     (map (lambda (m)
            (list (car m)
                  (if (url-string? (cadr m))
                    (concat prefix "/" (regexp-replace #rx"^/" (car m) ""))
                    (cadr m))))
          default-mappings))))

(define (do-mapping* path type)
  (let loop ([mappings mappings])
    (if (null? mappings)
      path
      (let ([cur (car mappings)])
        (cond [(and (eq? type (mapdata-type cur))
                    (regexp-match-positions (mapdata-from-re cur) path))
               => (lambda (m)
                    (do-mapping*
                     (concat (mapdata-to cur) (substring path (cdadr m)))
                     type))]
              [(and (eq? 'reverse type) ; map web-path to source-path
                    (regexp-match-positions (mapdata-to-re cur) path))
               => (lambda (m)
                    (do-mapping*
                     (concat (mapdata-from cur) (substring path (cdadr m)))
                     type))]
              [else (loop (cdr mappings))])))))
(define do-mapping
  (let ([tables (map (lambda (type) (cons type (make-hash)))
                     '(path url reverse))])
    (lambda (path type)
      (let ([table (cdr (assq type tables))])
        (hash-ref table path
          (lambda ()
            (let ([r (do-mapping* path type)])
              ;; [*] verify the result (we can get a partly mapped link like
              ;; /packages/..., so try to forward map both the input and r
              (when (and (eq? 'reverse type)
                         (not (equal? (do-mapping path 'path)
                                      (do-mapping r 'path))))
                (error 'do-mapping
                       "reverse-map doesn't match: ~a -rev-> ~a -map-> ~a"
                       path r (do-mapping r 'path)))
              (hash-set! table path r)
              r)))))))

(define (sourcepath->webpath path)
  (do-mapping path 'path))

(define (webpath->sourcepath path)
  (do-mapping path 'reverse))

(define (webpath->url path)
  (do-mapping path 'url))

;; ============================================================================
;; provided procedures for file creation

;; create the build directory and run thunk in there
(define* (with-converted-dir /path thunk)
  (let* ([/dir
          ;; Hack: if we get "foo/" then make it "foo/x" so dirname will return
          ;; the same directory (dirname will strip it off otherwise), this way
          ;; we get the same effect for "/foo/x.html" and "/foo/".
          (dirname (concat (sourcepath->webpath /path) "x"))]
         [target (concat (build-dir) /dir)])
    (make-directory* target)
    (parameterize ([current-directory target] [current-web-dir /dir])
      (thunk))))

(define* (run-file source)
  (let ([main (dynamic-require* source 'run (lambda () #f))]
        [subs (dynamic-require* source 'sub-pages (lambda () #f))])
    (eprintf (if (or main (pair? subs)) "running...\n" "skipping\n"))
    (when main (main))
    (when subs
      (for ([sub subs])
        (cond [(assq 'run (cdr sub)) => (lambda (run) ((cdr run)))])))))

(define (maybe-delete-file path)
  (when (or (file-exists? path) (link-exists? path))
    (delete-file path)))

(define* (install-file source . target)
  (unless (pair? target) (eprintf "copying...\n"))
  (let ([target (if (pair? target) (car target) (basename source))])
    (writing target)
    (maybe-delete-file target)
    (copy-file source target)))

(define* (write-string-to-file file string)
  (writing file)
  (with-output-to-file file #:exists 'truncate
    (lambda ()
      (display string)
      (unless (regexp-match-positions #rx"\n$" string) (newline)))))

(define* (create-filelink from to)
  (maybe-delete-file from)
  (writing from)
  (make-file-or-directory-link to from))

(define* (create-dirlink from to)
  (let* ([from  (regexp-replace #rx"/?$" from "")]
         [from/ (concat from "/")]
         [to    (regexp-replace #rx"/?$" to "")])
    (maybe-delete-file from)
    (writing/prefix from/)
    (make-file-or-directory-link to from)))

;; ============================================================================
;; link utilities

(define (remove-index.html path)
  (regexp-replace #rx"/index[.]html$" path "/"))
(define (add-index.html url)
  (if (regexp-match-positions #rx"^file://.*/$" url)
    (concat url "index.html")
    url))
(define (add-index.html* url)
  (if (regexp-match-positions #rx"/$" url)
    (concat url "index.html")
    url))

(define* (absolute-path path)
  (cond
    [(symbol? path) path]
    [(regexp-match #rx"^/" path) path]
    [(url-string? path) path]
    [(current-web-dir) (simplify-path* (concat (current-web-dir) "/" path))]
    [else (error 'absolute-path "relative path with no web-dir context: ~e"
                 path)]))

;; ============================================================================
;; provided procedures for link manipulation

(define* (url /path . noref?) ; expecting a source path or a url
  (cond [(symbol? /path) (symlink->url /path)]
        [(url-string? /path) /path]
        [else (let ([/path (remove-index.html
                            (sourcepath->webpath (absolute-path /path)))])
                (unless (and (pair? noref?) (car noref?))
                  (mark-as-referenced /path))
                (add-index.html (webpath->url /path)))]))

;; used to pull out a binding(s) from a source file, given its web-path, if the
;; file is not found and there is an index.ss, try it for a sub page
(define* (get-page-binding path symbol/s . default)
  ;; switch to the proper web-directory, in case the other module tries to do
  ;; something
  (let* ([/path (add-index.html* (absolute-path path))]
         [web-/path (sourcepath->webpath /path)] ; see [*]
         [dir (concat (build-dir) (dirname web-/path))]
         [srcpath (concat source-dir (html->ss (webpath->sourcepath /path)))]
         ;; search in sub pages of index.ss if the file is missing
         [indexpath
          (and (not (file-exists? srcpath))
               (let ([p (regexp-replace #rx"/[^/]*$" srcpath "/index.ss")])
                 (if (file-exists? p)
                   p (error 'get-page-binding "file not found: ~a" srcpath))))])
    (make-directory* dir)
    (parameterize ([current-directory dir]
                   [current-web-dir (dirname web-/path)])
      (if indexpath
        (let ([sub-pages (dynamic-require* indexpath 'sub-pages
                                           (lambda () #f))])
          (cond
            [(not sub-pages)
             (error 'get-page-binding
                    "~s not found, and ~s has no sub-pages" /path indexpath)]
            [(assoc (basename /path) sub-pages)
             => (lambda (page)
                  (let loop ([syms symbol/s])
                    (cond
                      [(and (pair? syms) (assq (car syms) (cdr page))) => cdr]
                      [(pair? syms) (loop (cdr syms))]
                      [(null? syms)
                       (if (pair? default)
                         (car default)
                         (error 'get-page-binding
                                "~s not found, and ~s:~s has no ~s binding"
                                /path indexpath (basename /path) symbol/s))]
                      [(assq syms (cdr page)) => cdr]
                      [else (loop '())])))]
            [else (error 'get-page-binding
                         "~s not found, and ~s has no ~s sub-page"
                         /path indexpath (basename /path))]))
        (let loop ([syms symbol/s])
          (cond
            [(null? syms)
             (if (pair? default)
               (car default)
               (error 'get-page-binding "~s has no binding for ~s"
                      /path symbol/s))]
            [(not (pair? syms)) (loop (list syms))]
            [else (dynamic-require* srcpath (car syms)
                                    (lambda () (loop (cdr syms))))]))))))

(provide import-from)
(define-syntax import-from
  (syntax-rules ()
    [(_ path id ...)
     (begin (define id (get-page-binding path 'id)) ...)]))

(define* (link-to path #:names [names '(link-title title)] #:label [label #f])
  (cond [(symbol? path) (symlink->link path)]
        [(url-string? path)
         (error 'link-to "can't guess the name of ~e" path)]
        [else (let* ([url (url path)]
                     [url (if label (string-append url "#" label) url)])
                `(a ([href ,url]) ,(get-page-binding path names)))]))

(define* (blurb-of path)
  (get-page-binding
   (if (symbol? path) (symlink-path (get-symlink path)) path)
   'blurb))

;; ============================================================================
;; symbols that are used for links

(define-struct symlink (title path link) #:mutable)
(define symlinks-table #f)
(define (build-symlinks-table)
  (define add-link
    (case-lambda
      [(name url) ; need to delay title lookups
       (add-link name (lambda () (get-page-binding url '(link-title title)))
                 url)]
      [(name title url)
       (hash-set! symlinks-table name (make-symlink title url #f))]))
  (set! symlinks-table (make-hash))
  (for ([xs symlinks]) (apply add-link xs)))
(define (get-symlink name)
  (unless symlinks-table (build-symlinks-table))
  (hash-ref symlinks-table name
    (lambda () (error 'get-symlink "symlink not found: ~e" name))))

(define (symlink-title* symlink)
  (let ([title (symlink-title symlink)])
    (when (procedure? title)
      (set! title (title))
      (set-symlink-title! symlink title))
    title))

(define (symlink->link name)
  (let ([link (get-symlink name)])
    (unless (symlink-link link)
      (set-symlink-link! link `(a ([href ,(url (symlink-path link))])
                                 ,(symlink-title* link))))
    (symlink-link link)))
(define (symlink->url name)
  (url (symlink-path (get-symlink name))))
(define (symlink->title name)
  (symlink-title* (get-symlink name)))

;; ============================================================================
;; tracing written pages and verifying links

;; this should be used with every file that is generated
(define written-pages '())
(define (written? path)
  (if (regexp? path)
    (member (object-name path) (map object-name written-pages))
    (ormap (lambda (w)
             (cond [(string? w) (equal? w path)]
                   [(regexp? w) (regexp-match w path)]
                   [else (error 'written? "internal error: ~e" w)]))
           written-pages)))

(define* (writing path)
  (let ([/path (remove-index.html (absolute-path path))])
    ;; (eprintf "Creating ~s\n" /path)
    (if (written? /path)
      (error 'writing "trying to overwrite: ~e" /path)
      (set! written-pages (cons /path written-pages)))))
(define* (writing/prefix prefix)
  (let ([/path (regexp
                (remove-index.html
                 (concat "^" (regexp-quote (remove-index.html
                                            (absolute-path prefix))))))])
    ;; (eprintf "Creating ~s\n" (object-name regexp))
    (if (written? /path)
      (error 'writing "trying to overwrite: ~e" /path)
      (set! written-pages (cons /path written-pages)))))

;; used to refer to files, and at the end check that references are fine
(define referenced-pages '())
(define (mark-as-referenced /path)
  (unless (member /path referenced-pages)
    (set! referenced-pages (cons /path referenced-pages))))

(add-exit-hook
 (lambda ()
   (for ([ref referenced-pages])
     (unless (written? ref) (warn "reference to uncreated page: ~a" ref)))))

