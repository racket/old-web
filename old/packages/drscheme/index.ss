#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "DrScheme")

(define blurb
  @`{DrScheme is a graphical, interactive programming environment.  In addition
     to editing and interactive execution facilities, DrScheme also provides
     various student-friendly features, integrated library support, and
     sophisticated analysis tools for advanced programmers.})

(define download-blurb
  @`{The PLT Scheme graphical programming environment.})

(define sys-req
  @system-requirements{
    @windows-versions, @osx-versions, or Unix running the X Window System.  The
    latest version of DrScheme is useful with at least 256MB of RAM in your
    computer, and installing requires roughly 60MB of disk space.})

(define tag 'plt)
(define download-pages
  (make-download-pages tag title sys-req "Download PLT Scheme"))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{DrScheme is an interactive, integrated, graphical programming
       environment that is included with @(link-to 'plt).}))

(begin-page (download-pages 'path+title)
  (define (run) (download-pages 'run panel)))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@(link-to 'tour)}
       @list{An overview of the DrScheme programming environment.}
       @list{@i{@a[href: (url "/download/doc/drscheme/")]{
                  PLT DrScheme: Programming Environment Manual}}}
       @list{The online version of the DrScheme manual.}
       @list{@(link-to 'docs)}
       @list{Complete PLT documentation in a variety of formats.}
       @list{@(link-to 'cookbook)}
       cookbook-desc))))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to 'planet)}
       planet-desc
       @list{@(link-to 'mzscheme)}
       @list{A console and embeddable Scheme implementation.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{DrScheme is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #f))))
