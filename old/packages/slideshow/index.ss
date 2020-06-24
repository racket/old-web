#reader"../../common/html-script.ss"

(define title "Slideshow")

(define blurb
  @`{Slideshow is a program and programming language for creating and running
     slide presentations within DrScheme.})

(define panel (make-panel title this-html-name))

(define (slideshow-ref href . body)
  (apply a href: (concat "http://www.cs.utah.edu/plt/slideshow/" href) body))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{Slideshow is a @(link-to 'plt)-supported language for creating and
       running slide presentations.  It's an alternative to PowerPoint (which
       offers little abstraction), HTML generation (which is inflexible), or
       PDF generation (which is static and often displays poorly).}
    @p{See the @(link-to "examples.html") or
       @a[href: "http://www.cs.utah.edu/plt/publications/jfp05-ff.pdf"]{
         JFP paper}
       (PDF) for an overview of Slideshow's language and capabilities.}
    @p{Slideshow is distributed as part of @(link-to 'plt).}
    @system-requirements{
      @windows-versions, @osx-versions, or Unix running the X Window System,
      plus @(link-to 'plt).}))

(begin-page "examples.html"
  (define title "Examples")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{Slideshow tutorial:
             @slideshow-ref["tutorial/tutorial-show.ss"]{source} and
             @slideshow-ref["tutorial/tutorial-show.pdf"]{PDF version}}
       @list{A tutorial that is distributed with Slideshow, and that you can
             run by starting the Slideshow executable with no arguments.}
       @list{@slideshow-ref["macro-slides/"]{Scheme Macros Overview}@br{}
             @slideshow-ref["macro-module-slides/"]{Macros and Modules}@br{}
             @slideshow-ref["semantic-cast-slides/"]{Semantic Casts}}
       @list{Conference talks}
       @list{@slideshow-ref["lang-as-os/"]{Languages as Operating Systems}}
       @list{A variant of the MrEd talk from ICFP'99 and LL2. Includes lots of
             interactive evaluation.}
       @list{@slideshow-ref["platos-meno-slides/"]{Plato's Meno}}
       @list{Plato's @cite{Meno} in slide form.  Contibuted by Daniel Lyle.}
       @list{@slideshow-ref["cs2010-f03-slides/"]{Utah CS2010 Course Slides}
             @br{}
             @slideshow-ref["cs3520-f02-slides/"]{Utah CS3520 Course Slides}}
       @list{Large sets of course slides.}))))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@a[href: "http://www.cs.utah.edu/plt/publications/icfp04-ff.pdf"]{
               Slideshow: Functional Presentations} (PDF)}
       @list{A conference paper that provides an overview of Slideshow.}
       @list{@slideshow-ref["tutorial/tutorial-show.pdf"]{Slideshow tutorial}
             (PDF)}
       @list{A printable version of the tutorial (that you can run by starting
             Slideshow).  See also the
             @slideshow-ref["tutorial/tutorial-show.ss"]{source}.})
      @p{For complete documentation, install DrScheme and search for
         @i{slideshow} in DrScheme's Help Desk.})))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to 'drscheme)}
       @list{A programming environment for creating programs (including
             Slideshow presentations) based on PLT Scheme.}
       @list{@(link-to 'mred)}
       @list{The graphical PLT Scheme language run-time system on which
             Slideshow is based.  MrEd is included with @(link-to 'plt).}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{Slideshow is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))
