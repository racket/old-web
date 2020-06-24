#reader"../../common/html-script.ss"

(define title "MrEd")

(define blurb
  @`{MrEd has two facets.  First, it is a portable, cross-platform graphical
     toolbox used to build DrScheme and other applications.  Second, it
     provides advanced linguistic facilities to enable process-like features
     within a single language run-time. @,em{Unless you intimately understand
       your needs, we recommend that you use @(link-to 'drscheme).}  MrEd is
     distributed as part of @,(link-to 'plt).})

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{@b{MrEd} is the name of the executable for running GUI programs
       that are implemented in @(link-to 'plt), and it is included in the
       normal PLT Scheme package.}))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@i{@a[href: (url "/download/doc/mred/")]{
                  PLT MrEd: Graphical Toolbox Manual}}}
       @list{The online version of the MrEd manual.}
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
       @list{@(link-to 'drscheme)}
       @list{A programming environment for creating MrEd programs.}
       @list{@(link-to 'mzscheme)}
       @list{The underlying Scheme implementation.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{MrEd is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #t))))
