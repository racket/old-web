#reader scribble/reader
#lang scheme/base

(require "paths.ss" "layout.ss" "html-xexprs.ss" "utils.ss")

(define* (PLT title) (concat "PLT " title))
(define* (PLT: title) (concat "PLT Scheme: " title))

(define* windows-versions "Windows (95 and up)")
(define* osx-versions     "Mac OS X (10.3 and up)")
(define* (system-requirements . body)
  (apply p @b{System Requirements: } body))

(define* (standard-support)
  (apply panel-menu
    `(;; blurbs are lists
      (,(link-to 'bug-report))
      ,(blurb-of 'bug-report)
      (,(link-to 'bug-query))
      ,(blurb-of 'bug-query)
      #f
      (,(link-to "/www/maillist/"))
      ,(blurb-of "/www/maillist/")
      (,(link-to "/www/maillist/espanol.html"))
      ,(blurb-of "/www/maillist/espanol.html")
      #f
      (,(link-to 'pre-release-installers))
      @,list{Pre-release software and documentation are built nightly from
             actively developed sources.})))

(define* (standard-learning drscheme?)
  (apply panel-menu
    `(,@(if drscheme?
          (list (list (link-to 'plt))
                @`{The PLT Scheme distribution includes the DrScheme programming
                   environment provides specific support for beginning
                   programmers.})
          '())
      @,list{@(link-to 'htdp) (@i{HtDP})}
      @,list{@i{HtDP} is the companion textbook to DrScheme.  The book employs
             Scheme to present a curriculum in modern program design
             principles.  It illustrates these ideas through a wide range of
             examples that are interesting and practical, including graphical
             games, Web page construction and file-system modelling.}
      (,(link-to 'teachscheme!))
      @,list{DrScheme and @i{HtDP} are at the heart of this project.  Its goal
             is to transform introductory curricula by presenting computer
             science in a way that belongs in the core of both a liberal arts
             and an engineering education.}
      (,(link-to 'fixnum))
      @,list{A brief Scheme tutorial for people who are already familiar with
             programming.}
      (,(link-to 'cookbook))
      @,list{Scheme recipes for common tasks in practical contexts @mdash a
             collaborative effort from Schematics.}
      (,(link-to 'schemers))
      @,list{General Scheme resources.})))

(define* planet-desc
  @`{Browse the current list of user-contributed packages.})

(define* cookbook-desc
  @`{Scheme recipes for common tasks in practical contexts @mdash a
     collaborative effort from Schematics.})
