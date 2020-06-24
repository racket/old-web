#reader"../../common/html-script.ss"

(define title "mzc")

(define blurb
  @list{@tt{mzc} is a Scheme-to-C compiler.  It is included with the
        @(link-to 'plt) and @(link-to 'mzscheme) distributions.})

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{@tt{mzc} is a command-line tool that is included with @(link-to 'plt).}))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@i{@a[href: (url "/download/doc/mzc/")]{
                  PLT mzc: MzScheme Compiler Manual}}}
       @list{The online version of the @tt{mzc} manual.}
       @list{@(link-to 'docs)}
       @list{Complete PLT documentation in a variety of formats.}))))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to 'drscheme)}
       @list{A programming environment for creating programs that @tt{mzc}
             compiles.}
       @list{@(link-to 'mzscheme)}
       @list{The primarly language of programs compiled by @tt{mzc}.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{@tt{mzc} is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #t))))
