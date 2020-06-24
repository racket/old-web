#reader"../../common/html-script.ss"

(define title "MrFlow")

(define blurb
  @`{MrFlow is a static debugger that performs control-flow analysis on a
     program to identify potential sources of errors, much like a type
     inference engine.})

(define sys-req @system-requirements{@ul{@li{@(link-to 'plt)}}})

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{Coming soon.}
    @p{MrFlow is a user friendly, interactive static debugger for
       @(link-to 'plt) that
       @ul{
         @li{highlights operations that may cause errors;}
         @li{computes invariants describing the set of values each program
             expression can assume; and}
         @li{provides a graphical explanation for each invariant.}}}
    @p{The programmer can browse this information, and then resume program
       development with an improved understanding of the program's execution
       behavior, and in particular of potential run-time errors.}
    sys-req))
