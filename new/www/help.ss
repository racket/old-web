#lang at-exp s-exp "shared.ss"

(require "common.ss")

(define/provide help
  (page #:title "Need Help?"
        #:offer-help? #f
   (parlist @strong{Don't Panic!}
            @text{PLT Scheme has a variety of resources designed to help you
                  with any problems you may have.})
   (parlist @strong{Help Desk}
            @text{Your first stop should always be with the help system that's
                  built into PLT Scheme and available from the DrScheme menu
                  @strong{or by pressing F1 with the cursor on a search term}.
                  This documentation is customized for your installation, and
                  may include documentation for optional packages you've
                  installed.  As a second line of defense, the documentation
                  for the core of the most recent version of PLT Scheme is
                  available
                  @a[href: "http://docs.plt-scheme.org"]{from this web site}.}
            @text{Not sure what to search for?  The documentation includes a
                  @a[href: "http://docs.plt-scheme.org/guide/"]{guide} (also
                  located in your local copy of the documentation) that
                  provides a narrative introduction to many of PLT Scheme's
                  features.})
   (parlist @strong{Learning how to Program}
            @text{Try going through @|htdp|.})
   (parlist @strong{Searching the Web}
            @text{The
                  @a[href: "http://www.schemecookbook.org"]{Scheme Cookbook} is
                  a wiki for Scheme snippets (though not a PLT-specific one).
                  Additionally, your favorite search engine may well provide
                  answers for many of your questions, particularly if you
                  include "PLT" as a search term.})
   (parlist @strong{The Mailing List}
            @text{The @tt{plt-scheme} mailing list is a great source for
                  answers to questions when the above resources don't pan out;
                  sign up for it in the @a[href: "community.html"]{community}
                  area of the website.})
   @br
   @text{Thanks for using PLT Scheme!}))
