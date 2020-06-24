#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "ProfessorJ")

(define blurb
  @`{A teaching environment for Java with language levels.})

(define (ProfJ other-title) (concat title " " other-title))

(define sys-req @system-requirements{@ul{@li{@(link-to 'plt)}}})

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{ProfessorJ is an extension of the @(link-to 'drscheme) development
       environment that supports variants of Java suitable for education and
       research.}
    @p{The pedagogic variants provide student-friendly subsets of Java with
       error messages based on the expected knowledge of an introductory
       programmer.}
    @p{From the research side, ProfessorJ has served as the vehicle for
       exploring two additions to the Java programming language.  The first
       supports interoperability between Scheme and Java. The second provides
       linguistic support for unit testing, with an integrated test reporting
       mechanism.}
    sys-req))

(begin-page "goto.html"
   (define title "ProfessorJ.org")
   (define (run)
     (write-panel-page panel title #:navkey 'download
       @p{Go to @a[href: "http://www.professorj.org/"]{ProfessorJ.org}
          for further information on using ProfessorJ})))

(begin-page "info.html"
  (define title "Extension information")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      @ul{@li{@(link-to "levels.html")}
          @li{@(link-to "dynamic.html")}
          @li{@(link-to "testing.html")}})))

