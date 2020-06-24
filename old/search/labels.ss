#!/bin/sh
#|
exec mzscheme -r "$0" "$@"
|#

(define plt-label "_cse_4yu6uuqr9ia")

(define scores ; maps symbolic scores to numbers
  '([main     1.0]
    [download 0.9]
    [mail     0.9] ; mailing lists are important
    [docs     0.8]
    [tdocs    0.7] ; docs in doc.txt, closer to code
    [code     0.6]
    [learn    0.5]
    [misccode 0.3]
    [other    0.3]
    [oldcode  -0.5]
    ))

(define labels
  ;; URL-pattern                 score    keywords...
  '(("plt-scheme.org/*"          main     (plt))
    ("download.plt-scheme.org/*" download (plt))
    ("bugs.plt-scheme.org/*"     code     (plt bugs))
    ("pre.plt-scheme.org/*"      code     (plt))
    ("svn.plt-scheme.org/*"      code     (plt))
    ("htdp.org/*"                learn    (plt learn))
    ("planet.plt-scheme.org/*"   misccode (plt))
    ("www.cs.utah.edu/plt/develop/*" oldcode (plt))
    ;; sub pages
    ("pre.plt-scheme.org/plt/*"                   code  (plt source))
    ("pre.plt-scheme.org/docs/html/*"             docs  (plt docs))
    ("pre.plt-scheme.org/plt/collects/*doc.txt"   tdocs (plt docs))
    ("plt-scheme.org/software/drscheme/tour/*"    main  (plt learn))
    ("plt-scheme.org/techreports/*"               main  (plt academic))
    ("plt-scheme.org/who/*"                       main  (plt academic))
    ("plt-scheme.org/publications.html"           main  (plt academic))
    ;; other plt sites
    ("www.cs.brown.edu/research/plt/*"            other (plt))
    ("www.cs.brown.edu/~sk/Publications/Papers/*" other (plt academic))
    ("www.ccs.neu.edu/scheme/*"                   other (plt))
    ("www.ccs.neu.edu/scheme/pubs/*"              other (plt academic))
    ("plt.cs.uchicago.edu/*"                      other (plt))
    ("people.cs.uchicago.edu/~robby/pubs/*"       other (plt academic))
    ("www.ece.northwestern.edu/~robby/pubs/*"     other (plt))
    ("www.cs.utah.edu/plt/*"                      other (plt))
    ("www.cs.utah.edu/plt/publications/*"         other (plt academic))
    ;; mailing lists
    ("list.cs.brown.edu/pipermail/plt-announce/*" mail  (plt))
    ("list.cs.brown.edu/pipermail/plt-scheme/*"   mail  (plt))
    ;; misc places
    ("teach-scheme.org/*"                         other (academic))
    ("www.htus.org/*"                             learn (learn))
    ("www.ccs.neu.edu/home/dorai/t-y-scheme/*"    other (learn))
    ("schemecookbook.org/*"                       learn (learn))
    ("sourceforge.net/projects/schematics/*"      other ())
    ("schemers.org/*"                             other ())
    ("srfi.schemers.org/*"                        other (docs))
    ("www.r6rs.org/*"                             other (docs))
    ))

(define (print-TSV)
  (define labelnum (apply max (map (lambda (x) (length (caddr x))) labels)))
  (printf "URL\tLabel")
  (do ([i 0 (add1 i)]) [(= i labelnum)] (printf "\tLabel"))
  (printf "\tScore\n")
  (for ([line labels])
    (printf "~a\t~a" (car line) plt-label)
    (do ([i 0 (add1 i)]
         [ls (caddr line) (if (null? ls) ls (cdr ls))])
        [(= i labelnum)]
      (printf "\t~a" (if (null? ls) "" (car ls))))
    (let* ([score (cadr line)]
           [score (cond [(assq score scores) => cadr]
                        [(symbol? score) (error "bad score")]
                        [else score])])
      (printf "\t~a\n" score))))

(print-TSV)
