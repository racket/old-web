#lang at-exp s-exp "shared.ss"

(require "common.ss")

(define bootstrap
  @a[href: "http://www.bootstrapworld.org/"]{Bootstrap})

(define grad-study
  @a[href: "http://www.plt-scheme.org/who/common-plt-app.html"]{graduate study})

(define techreports
  @a[href: "http://www.plt-scheme.org/techreports/"]{Technical Reports})
(define brown-pubs
  @a[href: "http://www.cs.brown.edu/~sk/Publications/Papers/"]{
    Brown PLT Publications})
(define nwu-pubs
  @a[href: "http://www.eecs.northwestern.edu/~robby/pubs/"]{
    Northwestern PLT Publications})
(define neu-pubs
  @a[href: "http://www.ccs.neu.edu/scheme/pubs/"]{
    Northeastern PLT Publications})
(define utah-pubs
  @a[href: "http://www.cs.utah.edu/plt/publications/"]{Utah PLT Publications})

(define/provide outreach+research
  (page
    #:title @span["Outreach" nbsp "&" nbsp "Research"]
    (parlist @strong{Outreach}
      @text{@teachscheme @mdash a workshop to train teachers using @htdp in the
        classroom.}
      @text{@bootstrap @mdash a curriculum for middle-school students.})
    (apply parlist @strong{Publications}
           (list techreports brown-pubs nwu-pubs neu-pubs utah-pubs))
    (parlist @strong{Graduate Study}
             @text{We welcome applications from students interested in @|grad-study|.})))
