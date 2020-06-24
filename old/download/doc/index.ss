#reader"../../common/html-script.ss"

(require scheme/file)

(define title "PLT Documentation")
(define link-title "All PLT Documentation")

(import-from "../bundle-information.ss" plt-version all-versions)

(define (create-doc-links)
  ;; links for all versions
  (for ([ver all-versions]) (create-dirlink ver (concat ftp-dir "doc/" ver)))
  ;; links for package htmls (used by old package pages)
  (for ([x '("drscheme" "insidemz" "mred" "mzc" "mzscheme")])
    (define target (url (concat "html/"x"/")))
    (make-directory* x)
    ;; use both an html redirection, and a more well-behaved .htaccess
    (write-redirect-page* (concat x "/index.html") target)
    @write-raw*[(concat x "/.htaccess")]{
      RedirectMatch 301 .* @target})
  ;; new links
  (create-dirlink "html" (concat ftp-dir "doc/" plt-version "/html/"))
  (create-dirlink "pdf"  (concat ftp-dir "doc/" plt-version "/pdf/")))

(define (run)
  (create-doc-links)
  (write-tall-page title #:search 'docs
    @p{If you have downloaded DrScheme, you can use @b{PLT Help} to browse the
       manuals: select @tt{Help Desk} in DrScheme's @tt{Help} menu, or start
       the @tt{PLT Help} application that is distributed with PLT Scheme.}
    @section{Online Documentation}
    @p{The manuals are also available on-line, in both
       @a[href: (url "html/")]{HTML} and @a[href: (url "pdf/")]{PDF} form.}
    @section{Older versions of documentation}
    @p{If you need documentation for older versions of PLT software:}
    (apply ul (map (lambda (ver)
                     @li{@a[href: (url (concat ver "/"))]{Version @ver}})
                   (cdr (reverse all-versions))))))
