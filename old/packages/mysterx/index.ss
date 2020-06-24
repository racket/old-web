#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "MysterX")

(define blurb
  @`{MysterX helps programmers script COM components.})

(define sys-req
  @system-requirements{
    @ul{@li{@windows-versions}
        @li{@(link-to 'plt) or @(link-to 'mzscheme)}
        @li{Internet Explorer version 4.x or newer
            (@a[href: (concat "http://www.microsoft.com/"
                              "windows/ie/downloads/default.asp")]{
               available here})}
        @li{Distributed COM, which comes with newer versions of Windows,
            available as a
            @a[href: "http://www.microsoft.com/com/resources/downloads.asp"]{
              download}
            for Windows 95/98}}})

(define tag 'mysterx)
(define download-pages
  (make-download-pages tag title sys-req "Download Old Versions"))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{MysterX ("Mister X") is a toolkit for building Windows applications
       within @(link-to 'plt) or @(link-to 'mzscheme) using ActiveX and
       COM components.  Dynamic HTML is used for component presentation and
       event-handling.}
    @p{MysterX is provided as part of the PLT Scheme distribution for Windows.
       The @a[href: (download-pages 'url)]{download} page provides older
       distributions.}
    @p{Further information about MysterX:
       @ul{@li{@a[href: "http://www.ccs.neu.edu/scheme/pubs#tools99-s"]{
                   MysterX: A Scheme Toolkit for Building Interactive
                   Applications with COM}
               @br{}
               @i{Paul Steckler} (TOOLS '99)}
           @li{@a[href: "http://www.ccs.neu.edu/scheme/pubs#scmfun2000-s"]{
                 Component Support in PLT Scheme}}}}
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
       @list{@(link-to "../mzcom/")}
       @list{Makes PLT MzScheme available to COM clients.}
       @list{@(link-to "../srpersist/")}
       @list{Allows PLT Scheme to connect to ODBC databases.}
       @list{@(link-to 'mzscheme)}
       @list{A console and embeddable Scheme implementation.}
       @list{@(link-to 'plt)}
       @list{The primary PLT Scheme implementation.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{MysterX is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #f))))
