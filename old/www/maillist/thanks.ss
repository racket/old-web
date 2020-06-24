#reader"../../common/html-script.ss"

(define title "Mailing Lists Appreciations")
(define blurb
  @`{Some blurb text here.})

#|
(import-from "index.ss" list-archive-url)
(define cache-dir
  (build-path (find-system-path 'temp-dir) "plt-maillist-thanks"))

(require (prefix-in - net/url) (prefix-in - html/html)
         xml scheme/port mzlib/inflate)

(define-struct archive (url month year id))
(define (archive>? a1 a2)
  (let ([y1 (archive-year a1)] [y2 (archive-year a2)])
    (if (= y1 y2)
      (> (archive-month a1) (archive-month a2))
      (> y1 y2))))

(define (get-archive-links)
  (define xml
    (-read-html-as-xml (-get-pure-port (-string->url list-archive-url))))
  (let loop ([xml `(root () ,@xml)])
    (cond [(element? xml) (loop (xml->xexpr xml))]
          [(not (pair? xml)) '()]
          [(and (eq? 'a (car xml))
                (= 3 (length xml))
                (string? (caddr xml))
                (regexp-match #rx"Gzip'd Text" (caddr xml))
                (assq 'href (cadr xml)))
           => cdr]
          [else (append* (map loop (cddr xml)))])))

(define (get-archives)
  (define remote-files (get-archive-links))
  (define months '("December" "November" "October" "September" "August"
                   "July" "June" "May" "April" "March" "February" "January"))
  (define urls
    (let ([base (-string->url list-archive-url)])
      (map (lambda (r) (-url->string (-combine-url/relative base r)))
           remote-files)))
  (define archives
    (map (lambda (r url)
           (let* ([m    (regexp-match
                         #rx"^(20[0-9][0-9])-([A-Z][a-z]*)\\.txt\\.gz$" r)]
                  [yyyy (and m (string->number (cadr m)))]
                  [mm   (cond [(and m (member (caddr m) months))
                               => length]
                              [else #f])])
             (if (and yyyy mm)
               (make-archive url mm yyyy (+ mm (* yyyy 100)))
               (error 'get-archives "unexpected remote link: ~e" r))))
         remote-files urls))
  (unless (< 50 (length archives))
    (error 'get-archives
           "suspiciously small number of remote links: ~e" (length archives)))
  (unless (equal? archives (sort archives archive>?))
    (error 'get-archives "remote link are not sorted"))
  ;; skip the newest one, so we process only complete archives
  (if (null? archives) null (cdr archives)))

(require "../../../../misc/thanks/thank.ss")

(define (count-archive ar)
  (define data   (format "~a.gz"  (archive-id ar)))
  (define output (format "~a.out" (archive-id ar)))
  (define url (archive-url ar))
  (unless (file-exists? data)
    (printf "Retrieving ~a...\n" url)
    (let ([in  (-get-pure-port (-string->url url))]
          [out (open-output-file data)])
      (dynamic-wind
        void
        (lambda () (copy-port in out))
        (lambda () (close-input-port in) (close-output-port out)))))
  (if (file-exists? output)
    (with-input-from-file output read)
    (let ([in (open-input-file data)]
          [out (open-output-file output)])
      (define-values (p-in p-out) (make-pipe))
      (define t
        (thread (lambda ()
                  (gunzip-through-ports in p-out)
                  (unless (eof-object? (read-string 10 in))
                    (error 'count-archive "trailing junk when reading ~s"
                           (archive-url ar)))
                  (close-output-port p-out))))
      (dynamic-wind
        void
        (lambda ()
          (printf "Counting ~a...\n" (archive-url ar))
          (let ([r (calc-thanks p-in)])
            (fprintf out "~s\n" r)
            (thread-wait t)
            r))
        (lambda ()
          (close-input-port in)
          (close-output-port out))))))

(define (retrieve-archives)
  (define archives (get-archives))
  (unless (directory-exists? cache-dir)
    (printf "Making ~a...\n" cache-dir)
    (make-directory cache-dir))
  (parameterize ([current-directory cache-dir])
    (map (lambda (ar)
           `(tr ([valign "top"])
              (td () (nobr ()
                       ,(format "~s-~s" (archive-year ar) (archive-month ar))))
              (td () (pre ()
                       ,@(map (lambda (x) (format "~s\n" x))
                              (count-archive ar))))))
         archives)))

|#

(define (run)
  (write-tall-page (PLT title)
    @section{Thanks Counts}
    ;; `(table ,@(retrieve-archives))
    @p{Disabled}
    ))
