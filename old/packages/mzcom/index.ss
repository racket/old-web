#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "MzCOM")

(define blurb
  @`{MzCOM turns @,(link-to "../mzscheme/") into an embeddable COM class.})

(define sys-req
  @system-requirements{
    @windows-versions is required.  You'll need a COM host environment, such
    as Visual BASIC, to load MzCOM.})

(define tag 'mzcom)
(define download-pages
  (make-download-pages tag title sys-req (concat "Download " title)))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{MzCOM is a COM class containing an embedded MzScheme.  With MzCOM, you
       can run Scheme code from your favorite COM host environment, such as
       Visual BASIC, Delphi, Visual FoxPro, Visual C++, or even PLT's
       @(link-to "../mysterx/").}
    @p{MzCOM is implemented as an @i{out-of-process} COM server, so that a host
       can run multiple MzCOM instances.}
    @p{If you want to use PLT Scheme to script COM components, then you'll want
       to use @(link-to "../mysterx/").}
    @p{MzCOM is provided as part of the PLT Scheme Windows distribution, use
       the download link to get older distributions.}
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
       @list{Allows PLT Scheme to use COM servers.}
       @list{@(link-to "../srpersist/")}
       @list{Allows PLT Scheme to connect to ODBC databases.}
       @list{@(link-to 'mzscheme)}
       @list{A console and embeddable Scheme implementation.}
       @list{@(link-to 'drscheme)}
       @list{The primary PLT Scheme implementation.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{MzCOM is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #f))))
