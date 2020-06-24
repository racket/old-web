#reader"../../common/html-script.ss"

(define title "Design Issues")

(define pages
  '("binding-spaces.html"
    "paramz.html"
    ["self-import.html" "Allowing Self-Import in Units"]
    ["list-primitives.html" "Revision of the List Primitive Names"]
    ["numbers.html" "Number formats and beginners"]
    ["mixins.html" "Mixins design"]
    ["zodiac-read.html" "Parameterization in Zodiac:read"]
    ["gui-test.html" "Enhancements to GUI tester"]
    ["dialog.html" "Enhancements to file dialogs"]
    ["integrate-test.html" "Integration testing strawman"]
    ["mred-critique.html" "MrEd critique"]
    ["multiple-interfaces.html" "Inheriting Multiple Interfaces"]
    ["exn.html" "Exceptions and modules"]
    ["error-display.html" "error-display-handler"]
    ;; Stuff that was not linked from the original page
    ;; "full-vs-advanced.html"
    ;; "pr-tests.html"
    ;; "release-policy.html"
    ))

(define (run)
  (write-tall-page title
    (apply ul (map (lambda (x)
                     (li (if (list? x)
                           (apply a href: (car x) (cdr x))
                           (link-to x))))
                   pages))))
