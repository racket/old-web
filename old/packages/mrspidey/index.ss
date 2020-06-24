#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "MrSpidey")

(define hidden? #t)

(define blurb
  @'{MrSpidey is a static debugger for DrScheme v103p1.})

(define sys-req
  @system-requirements{
    @(link-to 'plt) v103p1 running under @windows-versions, @osx-versions,
    or Unix with the X Window System.})

(define tag 'mrspidey)
(define download-pages
  (make-download-pages tag title sys-req (concat "Download " title)))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{MrSpidey is a static debugger for DrScheme v103p1.}
    @p{PLT is working on an improved static debugger, @(link-to "../mrflow/"),
       which will have many of the same features as MrSpidey.  MrFlow will
       appear in an upcoming release of DrScheme.}
    sys-req))

(begin-page (download-pages 'path+title)
  (define (run) (download-pages 'run panel)))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@i{@a[href: "/download/doc/103p1/html/mrspidey/"]{
                  PLT MrSpidey: Static Debugger Manual}}}
       @list{The online version of the MrSpidey manual.}
       @list{@(link-to 'docs)}
       @list{Complete PLT documentation in a variety of formats.}))))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to "../mrflow/")}
       @list{The upcoming static debugger for PLT Scheme.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{MrSpidey is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #f))))
