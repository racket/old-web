;; This module provides a search-box function
#lang scheme/base
(require "search-info.ss" "../common/utils.ss" "../common/paths.ss")
(provide search-box)
;; The mode argument can be:
;; * 'plt -- search all plt-tagged pages (implemented as `hq')
;; * 'results -- special version for the search results page
;; * any other symbols should be a valid tag withing the PLT custom search
;;   engine, `plt' is used implicitly for these too
(define (search-box mode)
  (define results? (eq? 'results mode))
  (define small-text (if results? '() '((style "font-size: 75%;"))))
  (define (set-hq-field str)
    (format "window.document.getElementById(~s).hq.value = ~s;" form-id str))
  (define clear-hq-field
    (concat "window.document.getElementById('"form-id"').hq.value = '';"))
  (define button
    (concat "Search " (case mode
                        [(plt results) "PLT"]
                        [(source)   "Sources"]
                        [(docs)     "Documentation"]
                        [(academic) "Academic Pages"]
                        [(learn)    "Learning Pages"]
                        [(bugs)     "Bugs"]
                        [else (error 'search-box "unknown mode: ~e" mode)])))
  ;; The extra div and style properties make the box into a character-like box,
  ;; see http://www.cs.tut.fi/~jkorpela/forms/extraspace.html for details
  ;; (bottom of the page)
  `(div ([style "display: inline; margin: 0; white-space: nowrap;"])
     (form ([id ,form-id] [action ,(url "/www/search/")]
            [style "display: inline; margin: 0;"])
       (input ([type "hidden"] [name "cx"] [value ,plt-id]))
       (input ([type "text"]   [name "q"]  [size "16"] ,@small-text))
       ;; by default, searches are always for plt-tagged pages
       ;; (this will carry over from search to search)
       (input ([type "hidden"] [name "hq"] [value "more:plt"]))
       ;; this is my hack: the value of this field will be added to set the
       ;; default refinement
       (input ([type "hidden"] [name "cxq"]
               [value ,(if (memq mode '(plt results))
                         "" (concat "more:"mode))]))
       (input ([type "submit"] [name "sa"]  [value ,button] ,@small-text
               ,@(if results? `([onClick ,(set-hq-field "more:plt")]) '())))
       ,@(if results?
           `((br)
             (input ([type "submit"] [name "sa"]
                     [value "Search Additional Sites"]
                     [onClick ,(set-hq-field "")])))
           '())
       (input ([type "hidden"] [name "cof"] [value "FORID:9"])))))
