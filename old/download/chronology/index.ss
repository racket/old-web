#reader"../../common/html-script.ss"

(define title "Release Chronology")

(define announcements-filename
  (simplify-path (build-path source-dir announcements-file)))

(define-struct ann (system version year month day [text #:mutable]))

(define (ann->datenumber ann)
  (+ (ann-day ann) (* (+ (ann-month ann) (* (ann-year ann) 100)) 100)))

(define (ann-file ann)
  (format "~a~a.html"
          (or (ann-system ann) (error 'ann-file "entry with no system"))
          (if (ann-version ann)
            (regexp-replace #rx"/" (ann-version ann) "_")
            (ann->datenumber ann))))

(require version/utils)

(define announcements
  (with-input-from-file announcements-filename
    (lambda ()
      (define (ann<? a1 a2)
        (let ([n1 (ann->datenumber a1)]
              [n2 (ann->datenumber a2)])
          (cond [(< n1 n2) #t]
                [(> n1 n2) #f]
                [else (< (or (version->integer (ann-version a1)) 0)
                         (or (version->integer (ann-version a2)) 0))])))
      (define marker-re #rx"^{{{.*}}} *$") ; to catch errors
      (define entry-re
        (regexp (string-append
                 "^{{{ *"
                 "\\(([0-9][0-9][0-9][0-9]) ([0-9][0-9]) ([0-9][0-9])\\)"
                 " *(racket|plt|mzmr|mz|mr|drs) *([^ ]+)? *}}} *$")))
      (define (del-blanks l)
        (if (and (pair? l) (equal? "" (car l))) (del-blanks (cdr l)) l))
      (let loop ([as null])
        (let ([line (read-line)])
          (cond [(eof-object? line)
                 (for ([a as])
                   (set-ann-text! a
                     (del-blanks (reverse (del-blanks (ann-text a))))))
                 (sort as ann<?)]
                [(regexp-match entry-re line) =>
                 (lambda (m)
                   (apply (lambda (year month day system version)
                            (loop (cons (make-ann (string->symbol system)
                                                  version
                                                  (string->number year)
                                                  (string->number month)
                                                  (string->number day)
                                                  null)
                                        as)))
                          (cdr m)))]
                [(regexp-match marker-re line)
                 (error 'announcements "Bad marker line in ~a: ~s"
                        announcements-filename line)]
                [(null? as) (loop as)]
                [else (set-ann-text! (car as)
                                     (cons line (ann-text (car as))))
                      (loop as)]))))))

(define (run)
  (define bgcolor "#e0e0e0")
  (define fgcolor "#606060")
  (define rows
    ;; makes a list of rows, each one is a list of announcement entries.  `plt'
    ;; versions have their own row, the rest share.  the result is backwards,
    ;; but each row is forward.
    (let loop ([as announcements] [result null])
      (if (null? as)
        result
        (loop (cdr as)
              ;; a new row starts with a plt entry or a non-plt after one.
              (if (or ; #t ; to disable (and have everything on its own row)
                   (null? result)
                   (eq? 'plt (ann-system (car as)))
                   (eq? 'plt (ann-system (caar result))))
                (cons (list (car as)) result)
                (cons (cons (car as) (car result)) (cdr result)))))))
  (define (month->string month)
    (case month
      (( 1) "January") (( 2) "February") (( 3) "March")
      (( 4) "April")   (( 5) "May")      (( 6) "June")
      (( 7) "July")    (( 8) "August")   (( 9) "September")
      ((10) "October") ((11) "November") ((12) "December")))
  (define (do-cell entry)
    (let* ([system (ann-system entry)]
           [system-name
            (case system
              [(racket) `("Racket")]
              [(plt)    `("PLT" nbsp "Scheme")]
              [(mzmr)   `("MzScheme/MrEd")]
              [(mz)     `("MzScheme")]
              [(mr)     `("MrEd")]
              [(drs)    `("DrScheme")]
              [else (error 'announcements "Bad system name ~s" system)])]
           [version (ann-version entry)]
           [label   (if version
                      `(,@system-name nbsp
                        (tt () ,(if (eq? 'plt system)
                                  `(b () "v" ,version)
                                  version)))
                      system-name)]
           [year    (number->string (ann-year entry))]
           [month   (month->string  (ann-month entry))]
           [day     (number->string (ann-day entry))]
           [ref     (and (not (null? (ann-text entry))) (ann-file entry))]
           [date    `((small () "(" ,month nbsp ,day "," nbsp ,year ")"))]
           [label   `((font ((color ,(case system
                                       [(racket) "black"]
                                       [(plt) "black"]
                                       [(mzmr mz mr) "#e03020"]
                                       [(drs) "#2030e0"])))
                            ,@label)
                      nbsp
                      (font ((color ,fgcolor)) ,@date))])
      (if ref `((a ((href ,(url ref))) ,@label)) label)))
  (define (do-row entries)
    (let* ([major? (eq? 'plt (ann-system (car entries)))]
           [maybe-small (if major?
                          (lambda (xs) xs)
                          (lambda (xs) `((small () ,@xs))))])
      `(tr (,@(if major? `((bgcolor "#b0ffb0")) `()))
         (td ((align "center"))
           (font ((color ,bgcolor))
             ,@(maybe-small (mappend/sep do-cell ", " entries)))))))
  (write-tall-page (PLT title) #:search 'source
    @p{The following are the release dates for PLT Scheme, in reverse
       chronological order.  "PLT" entries are main releases, "MzScheme/MrEd"
       are releases of the core system, and "DrScheme" are releases of the
       Scheme code.  The PLT releases are usually advertised to the world and
       packaged for distribution, but the others are typically only released
       via Subversion and announced on the mailing list.  Version 53 is the
       oldest that is still distributed.}
    @br{}@br{}
    (apply table align: 'center border: 1 bordercolor: fgcolor bgcolor: bgcolor
           cellspacing: 0 cellpadding: 4 ; rules: 'groups
           (map do-row rows))))

(for ([a announcements])
   (let ([text (ann-text a)])
     (unless (null? text)
       (begin-page (ann-file a)
         (define (run)
           (write-xexpr
             @html{@body{@hr{}
                         @(apply pre (map (lambda (x) (string-append x "\n"))
                                          text))
                         @hr{}}}))))))
