#reader"../common/html-script.ss"

(define title "Code Responsibility")

(define root-dir "~scheme/checkout/trunk")
(define prop "plt:responsible")
(define prop-re #rx#"(?:^|\n)  plt:responsible\n")

(define (read-tree)
  (let loop ([dir #"."])
    (parameterize ([current-directory (bytes->path dir)])
      (cons dir
            (filter values
                    (map (lambda (x)
                           (let ([p (bytes->path x)])
                             (cond [(member x '(#".svn" #"CVS")) #f]
                                   [(file-exists? p) x]
                                   [(directory-exists? p) (loop x)]
                                   [else (error "something bad happened")])))
                         (sort (map path->bytes (directory-list))
                               bytes<?)))))))

(define (cmd->port exe . args)
  (let-values ([(p pout pin perr)
                (apply subprocess #f #f (current-error-port)
                       (find-executable-path exe #f) args)])
    (close-output-port pin)
    pout))

(define (port->bytes port)
  (define buf (make-bytes 1024))
  (parameterize ([current-output-port (open-output-bytes)])
    (let loop ()
      (let ([len (read-bytes! buf port)])
        (if (eof-object? len)
          (get-output-bytes (current-output-port))
          (begin (write-bytes (subbytes buf 0 len)) (loop)))))))

(define (propget path)
  (let* ([r (port->bytes (cmd->port "svn" "--strict" "propget" prop path))]
         [r (regexp-replace #rx#"\n$" r #"")])
    (unless (regexp-match #rx#"^[a-z][a-z,]+[a-z]$" r)
      (error 'propget "bad value for ~a in \"~a\": ~s" prop path r))
    r))

(define (find-props)
  (define inp (cmd->port "svn" "proplist" "-R" "."))
  (let loop ([r '()])
    (let* ([m (regexp-match #rx#"^Properties on '([^\n]+)':\n((?:  [^\n]*\n)+)"
                            inp)]
           [m (or m (read-bytes-line inp))])
      (cond [(pair? m)
             (if (regexp-match-positions prop-re (third m))
               (loop (cons (list (second m)
                                 (propget (bytes->string/utf-8 (second m))))
                           r))
               (loop r))]
            [(bytes? m) (error 'find-props "bad input format in line: ~a" m)]
            [(eof-object? m) (reverse r)]
            [else (error "something bad happened")]))))

(define (set-props tree props)
  (define table (make-weak-hasheq))
  (define (propset path user)
    (let loop ([t (cdr tree)] [p (regexp-split #rx#"/" path)])
      (cond [(null? p) (hash-set! table t user)]
            [(null? t) (error 'set-prop "path not found: ~a" path)]
            [(equal? (if (pair? (car t)) (caar t) (car t)) (car p))
             (loop (car t) (cdr p))]
            [else (loop (cdr t) p)])))
  (for ([path+user props]) (apply propset path+user))
  table)

(define (thin-tree tree props)
  ;; user field: #f => nobody, * => nobody, but see children
  (car
   (let loop ([t tree] [user #f])
     (let ([user (hash-ref props t (lambda () user))])
       (if (bytes? t)
         (cons t user)
         (let* ([xs    (map (lambda (x) (loop x user)) (cdr t))]
                [same? (andmap (lambda (x) (equal? user (cdr x))) xs)]
                [t     (if same? (list (car t)) (cons (car t) (map car xs)))]
                [user  (if same? user '*)])
           (when user (hash-set! props t user))
           (unless same?
             (for ([x xs] #:when (cdr x)) (hash-set! props (car x) (cdr x))))
           (cons t user)))))))

(define (-dir name)
  `((b () ,(format "~a" name)) "/"))
(define (-file name)
  `((b () ,(format "~a" name))))
(define (-owner name)
  (if (eq? '* name)
    '()
    `(" : " (b () ,(if name
                     (format "~a" name)
                     `(font ([color "red"]) "none!"))))))

(define (tree->lines tree props)
  (let loop ([pfx ""] [elts (cdr tree)])
    (let ([last (and (pair? elts) (last elts))])
      (apply
       append
       (map (lambda (x)
              (let* ([dir? (pair? x)]
                     [this (if dir? (car x) x)]
                     [user (hash-ref props x (lambda () #f))])
                (cons `(,pfx ,(if (eq? last x) "`-- " "|-- ")
                        ,@((if dir? -dir -file) this)
                        ,@(-owner user) "\n")
                      (if dir?
                        (loop (string-append pfx "|   ") (cdr x)) '()))))
            elts)))))

(define (lines)
  (let* ([tree  (read-tree)]
         [props (set-props tree (find-props))])
    (append* (-dir "plt") '("\n") (tree->lines (thin-tree tree props) props))))

(define (run)
  (write-tall-page title
    @p{(See the description on the
       @(link-to "svn.html" #:label "responsibility") page.)}
    (let ([root (with-handlers ([exn:fail:filesystem? (lambda (_) #f)])
                  (expand-user-path root-dir))])
      (if (and root (directory-exists? root))
        (parameterize ([current-directory root])
          @table[align: 'center]{@tr{@td{@(apply pre (lines))}}})
        @p{@font[color: 'red]{@b{
          Clean repository not found at @tt{@root-dir}.}}}))))
