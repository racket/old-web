#lang at-exp s-exp "shared.ss"

(require "common.ss")

(define (maillist-email name)
  (tt (big (strong name)) "@list.cs.brown.edu"))
(define (maillist-url name)
  (define url "http://list.cs.brown.edu/")
  @text{@a[href: `(,url "mailman/listinfo/" ,name "/")]{Subscribe}
        or @a[href: `(,url "pipermail/" ,name "/")]{browse}})
(define (gmane name)
  @a[href: `("http://dir.gmane.org/gmane.lisp.scheme." ,name)]{Gmane})
(define google-groups
  @a[href: "http://groups.google.com/group/plt-scheme"]{Google Groups})
(define people @a[href: "http://www.plt-scheme.org/who/"]{People})

(define svn
  @a[href: "http://svn.plt-scheme.org/"]{Development Repository})
(define pre-installers
  @a[href: "http://pre.plt-scheme.org/installers/"]{
    Pre-built development installers})
(define pre-stuff
  @a[href: "http://pre.plt-scheme.org/"]{Other Pre-built Resources})
(define announcements
  @a[href: "http://download.plt-scheme.org/chronology/"]{Release Announcements})

(define/provide community
  (page
    (parlist @strong{Mailing Lists}
      @text{@maillist-email{plt-scheme} @mdash a discussion list for all things
        related to PLT Scheme.  Ask your questions here!
        (@maillist-url{plt-scheme}, also via @gmane{plt} and
        @|google-groups|.)}
      @text{@maillist-email{plt-announce} @mdash a low-volume, moderated list
        for announcements, only.  (@maillist-url{plt-announce}.)}
      @text{@maillist-email{plt-dev} @mdash a mailing list for PLT Scheme
        development, for the people who want to see how the sausages are made and help make them.
        (@maillist-url{plt-dev}@";" also on @gmane{plt.dev}.)})
    (parlist @strong{Resources for Learning}
      (apply parlist @text{Documentation for getting started:} intros)
      @text{@schematics @mdash full of useful recipes.}
      @text{@htdp @mdash a textbook for introductory programming, but also
        worthwhile for experience programmers who are new to @|ldquo|functional
        programming.@|rdquo|}
      @text{@plai @mdash a textbook on programming languages.}
      @text{@teachscheme @mdash a workshop to train teachers using @htdp in the
        classroom.}
      @text{@schemers @mdash general Scheme resources})
    (parlist @strong{PLT Scheme Inc.}
      @text{@|blog| @mdash announcements, helpful hints, and thoughtful rants.}
      @text{@people @mdash the people behind PLT Scheme.})
    (parlist @strong{Development}
      svn
      @text{@pre-installers and @|pre-stuff|.}
      announcements)))
