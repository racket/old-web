#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "OpenSSL for PLT")

(define blurb
  @'{The OpenSSL binding provides a Scheme interface to essential OpenSSL
     functions.})

(define sys-req
  @system-requirements{
    PLT @(link-to 'mzscheme) or @(link-to 'plt).  For Windows, the download
    comes with OpenSSL libraries.  For many versions of Linux and Unix, OpenSSL
    libraries are already installed.
    @font[color: 'red]{On some Unix versions, including older versions of Mac
      OS X, you may need to install libraries yourself.}
    See @a[href: "http://www.openssl.org/"]{the OpenSSL Web site} for downloads
    and more information.
    @br{}
    Installing the libraries requires at most 2 Mb of disk space.})

(define tag 'openssl)
(define download-pages
  (make-download-pages tag title sys-req "Download Old Versions"))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{@a[href: "http://www.openssl.org"]{OpenSSL} is a project to make the
       Secure Sockets Layer (SSL) and Transport Layer Security (TLS) protocols
       and a cryptography library available for general use.  PLT provides a
       Scheme interface to some of the OpenSSL functionality through its
       @tt{openssl} collection.}
    @p{The @tt{openssl} collection is now part of the PLT Scheme distribution.
       See the @a[href: (download-pages 'url)]{download} page to get older
       distributions.}))

(begin-page (download-pages 'path+title)
  (define (run) (download-pages 'run panel)))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@(link-to 'docs)}
       @list{Complete PLT documentation in a variety of formats.}))))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to 'planet)}
       planet-desc
       @list{@(link-to 'drscheme)}
       @list{A programming environment for creating programs based on PLT
             Scheme.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{PLT Scheme is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))
