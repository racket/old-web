#lang scheme/base

(require "conf.ss" scheme/list)

(provide define*)
(define-syntax define*
  (syntax-rules ()
    [(define* (name . xs) body ...) (define* name (lambda xs body ...))]
    [(define* var val) (begin (provide var) (define var val))]))

(define* (eprintf fmt . args)
  (apply fprintf (current-error-port) fmt args))

(define* (->string x)
  (cond [(string? x) x]
        [(path? x)   (path->string x)]
        [(symbol? x) (symbol->string x)]
        [(number? x) (number->string x)]
        [else (error '->string "bad balue: ~e" x)]))

(define* (concat . args) (apply string-append (map ->string args)))

(define* (mappend f l . ls)
  (append* (apply map f l ls)))
(define* (map/sep f sep l . ls)
  (cdr (append* (map (lambda (x) (list sep x)) (apply map f l ls)))))
(define* (mappend/sep f sep l . ls)
  (cdr (append* (map (lambda (x) (cons sep x)) (apply map f l ls)))))

(define* (ss->html str)
  (regexp-replace #rx"[.]ss$" str ".html"))

(define* (html->ss str)
  (regexp-replace #rx"[.]html$" str ".ss"))

;; path utilities all operate with strings

(define* (dir . path) ; like directory-list, but blind to "CVS" and ".*"
  (filter (lambda (x) (not (regexp-match-positions ignored-files x)))
          (map path->string (apply directory-list path))))

(define* (dirname str)
  (cond [(regexp-match #rx"^(.*)/[^/]+/?$" str) => cadr]
        [else (error 'dirname "bad path string: ~e" str)]))

(define* (basename str)
  (cond [(regexp-match #rx"^.*/([^/]+)/?$" str) => cadr]
        [else (error 'basename "bad path string: ~e" str)]))

(define* (split-path* str)
  (cond [(regexp-match #rx"^(.*)/([^/]+)/?$" str)
         => (lambda (m) (apply values (cdr m)))]
        [else (error 'split-path* "bad path string: ~e" str)]))

(define* (simplify-path* str)
  (if (not (regexp-match-positions #rx"(^|/)[.][.]?(/|$)" str))
    str
    (let loop ([elts (regexp-split #rx"/" str)] [path '()])
      (cond [(null? elts) (apply concat (map/sep values "/" (reverse path)))]
            [(equal? "." (car elts)) (loop (cdr elts) path)]
            [(equal? ".." (car elts))
             (if (null? path)
               (error 'simplify-path* "internal error")
               (loop (cdr elts) (cdr path)))]
            [else (loop (cdr elts) (cons (car elts) path))]))))

(define* (url-string? str)
  (regexp-match-positions #rx"^[^/]+://" str))

(define* (dynamic-require* file sym . default-thunk)
  (with-handlers
      ([exn:fail:contract?
        (lambda (e)
          (if (and (pair? default-thunk)
                   (regexp-match #rx"dynamic-require: name is not provided"
                                 (exn-message e)))
            ((car default-thunk))
            (raise e)))])
    (dynamic-require `(file ,file) sym)))

;; for code that check stuff
(define exit-hooks '())
(define* (add-exit-hook thunk) (set! exit-hooks (cons thunk exit-hooks)))
(define* (run-exit-hooks) (for ([thunk exit-hooks]) (thunk)))

(define* warnings? (make-parameter #f))
(define* (warn fmt . args)
  (eprintf "WARNING: ~a\n" (apply format fmt args))
  (warnings? #f)) ;!!! go on, things in here are a hack anyway
