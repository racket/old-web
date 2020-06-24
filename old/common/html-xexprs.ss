#lang scheme/base
(require (for-syntax scheme/base))

(define-struct attr (key))

(define (convert-quotes s)
  (define (replace sym)
    (lambda (m)
     (append (convert-quotes (substring s (cdar m)))
             (list sym)
             (convert-quotes (substring s 0 (caar m))))))
  (cond
   [(not (string? s)) (list s)]
   [(regexp-match-positions #rx"``" s) => (replace 'ldquo)]
   [(regexp-match-positions #rx"''" s) => (replace 'rdquo)]
   [(regexp-match-positions #rx"'" s) => (replace 'rsquo)]
   [else (list s)]))

;; used for splicing lists into xexprs
(define-struct splice (contents))
(provide (rename-out [splice-args splice]))
(define (splice-args . xs) (make-splice xs))
(define (do-splicing l)
  (let loop ([l l] [r '()])
    (cond
      [(null? l) (reverse r)]
      [(splice? (car l)) (loop (append (splice-contents (car l)) (cdr l)) r)]
      [else (loop (cdr l) (append (convert-quotes (car l)) r))])))

(define (to-string x)
  (if (string? x) x (format "~a" x)))

(define (make-xexpr name args)
  (let loop ([attrs '()] [body args])
    (cond [(or (null? body) (not (attr? (car body))))
           (list* name (reverse attrs) (do-splicing body))]
          [(null? (cdr body))
           (error 'html-xexpr "missing argument for keyword: ~e"
                  (attr-key (car body)))]
          [else (loop (cons (list (attr-key (car body))
                                  (to-string (cadr body)))
                            attrs)
                      (cddr body))])))

;; like list, but does splicing
(provide text)
(define (text . args)
  (let ([xexpr (make-xexpr 'text args)])
    (if (null? (cadr xexpr))
      (cddr xexpr)
      (error 'text "cannot handle attributes"))))

(define-syntax make-xexpr-constructors
  (syntax-rules ()
    [(_ name ...)
     (begin (define (name . args) (make-xexpr 'name args)) ...
            (provide name ...))]))

(define-syntax (make-xexpr-known-keys stx)
  (syntax-case stx ()
    [(_ name ...)
     (with-syntax ([(name: ...)
                    (map (lambda (n)
                           (datum->syntax
                            n
                            (string->symbol
                             (string-append (symbol->string (syntax->datum n))
                                            ":"))
                            n))
                         (syntax->list #'(name ...)))])
       #'(begin (define name: (make-attr 'name)) ...
                (provide name: ...)))]))

(define-syntax make-xexpr-entities
  (syntax-rules ()
    [(_ name ...)
     (begin (define name 'name) ...
            (provide name ...))]))

(make-xexpr-constructors
 html body div span p a br hr nobr h1 h2 h3 h4 pre blockquote cite
 table th tr td ul ol li dl dt dd
 big small strong em i b u tt code sub font img
 script form input textarea select option
 section) ; <- special processing in layout.ss
(make-xexpr-known-keys
 href style class align valign width height color bgcolor bordercolor
 cellpadding cellspacing colspan rowspan border start vspace
 src action method type name id value size rows cols selected
 alt title
 onload onfocus onblur onchange onsubmit
 onkeyup onkeydown onclick onmouseover onmouseout)
(make-xexpr-entities nbsp mdash bull)
