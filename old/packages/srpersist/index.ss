#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "SrPersist")

(define blurb
  @`{SrPersist connects to ODBC drivers for database access.})

(define sys-req
  @system-requirements{
    @(link-to 'mzscheme) or @(link-to 'plt) must be installed.  In the DrScheme
    Windows distribution, a binary version of the SrPersist extension is
    provided, using the Microsoft Driver Manager.  For other platforms, you
    will need to compile SrPersist using your choice of Driver Manager.
    Compilation directions are provided in the source directory,
    @tt{plt/src/srpersist}.
    @br{}
    To use the Windows precompiled binary, you must have the ODBC Data Manager
    installed.  Look in Windows Control Panel for this application.  If it is
    missing, download and install Microsoft Data Access Components from the
    @a[href: "http://www.microsoft.com/data/"]{Universal Data Access Page}.})

(define tag 'srpersist)
(define download-pages
  (make-download-pages tag title sys-req (concat "Download " title)))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{SrPersist ("Sister Persist") is a set of Scheme bindings for the
       @a[href: "http://www.microsoft.com/data/odbc/"]{
         Open Database Connectivity (ODBC)}
       standard.  SrPersist runs under either @(link-to 'mzscheme) or
       @(link-to 'plt) on @|windows-versions|, @|osx-versions|, and various
       versions of Unix.}
    @p{SrPersist performs extensive error-checking that is not done when using
       the C version of the ODBC API.  ODBC errors result in Scheme exceptions.
       While SrPersist implements only ODBC, and little else, it offers
       definite advantages over the ODBC C API.}
    @p{Francisco Solsona has built
       @a[href: "http://sourceforge.net/projects/schematics/"]{SchemeQL}
       (in beta), a database layer that uses SrPersist.  SchemeQL programmers
       do not need particular knowledge of ODBC.}
    sys-req))

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
       @list{@(link-to "../mysterx/")}
       @list{Allows PLT Scheme to script COM servers.}
       @list{@(link-to "../mzcom/")}
       @list{Makes PLT MzScheme available to COM clients.}
       @list{@(link-to 'mzscheme)}
       @list{A console and embeddable Scheme implementation.}
       @list{@(link-to 'drscheme)}
       @list{The primary PLT Scheme implementation.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{SrPersist is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #f))))
