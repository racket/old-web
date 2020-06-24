#reader"../common/html-script.ss"

(define title "PLT Scheme")

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title
    @p{@strong{PLT Scheme} is an umbrella name for a family of
       @a[href: (url 'software)]{implementations} of the
       @a[href: (url 'schemers)]{Scheme} programming language.}
    @br{}
    @p{@strong{PLT} is the @a[href: (url "who/")]{group of people} who produce
       PLT Scheme.   We welcome applications from students interested in
       @a[href: (url "who/common-plt-app.html")]{graduate study}.}
    @p{@(link-to 'drscheme) is the primary PLT Scheme implementation.}
    @p{@(link-to 'teachscheme!) is a PLT project to turn Computing and
       Programming into an indispensable part of the liberal arts curriculum.}
    @p{@(link-to 'htdp) (@i{HtDP}) is a textbook for introductory programming
       that was written by several PLT members.}
    @p{@(link-to 'planet) is PLT's centralized package distribution system.
       Visit for a list of user-contributed packages.}
    @p{@(link-to 'htus) (@i{HtUS}) is a book about using PLT Scheme for
       everyday programming tasks.  (Still a work in progress.)}
    @p{@(link-to 'mzscheme) is the lightweight, embeddable, scripting-friendly
       PLT Scheme implementation.}))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs
      (panel-menu
       @list{@(link-to 'tour)}
       @list{An overview of the DrScheme programming environment.}
       @list{@(link-to 'docs)}
       @list{Complete documentation for PLT software in a variety of formats
             for the current release.}
       #f
       @list{@(link-to 'cookbook)}
       cookbook-desc
       #f
       @list{@(link-to 'pre-release-docs)}
       @list{Documentaton for pre-release software is built nightly from our
             actively developed sources.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run) (write-panel-page panel title (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn (standard-learning #t))))

(begin-page "publications.html"
  (define title "Publications")
  (define (run)
    (write-panel-page panel title #:search 'academic
      (panel-menu
       @list{@(link-to 'techreports)}
       @list{Technical reports from PLT}
       @list{@(link-to 'htdp)}
       @list{A textbook}
       #f
       @list{@a[href: "http://www.cs.brown.edu/~sk/Publications/Papers/"]{
               Brown PLT Publications}}
       @list{Research papers from PLT at Brown}
       @list{@a[href: "http://www.ece.northwestern.edu/~robby/pubs/"]{
               Chicago PLT Publications}}
       @list{Research papers from PLT at Chicago}
       @list{@a[href: "http://www.ccs.neu.edu/scheme/pubs/"]{
               Northeastern PLT Publications}}
       @list{Research papers from PLT at Northeastern}
       @list{@a[href: "http://www.cs.utah.edu/plt/publications/"]{
               Utah PLT Publications}}
       @list{Research papers from PLT at Utah}))))
