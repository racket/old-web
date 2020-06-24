#reader"../../common/html-script.ss"

(define title "Software Patches")

(define (patch-title)
  (let-values ([(base name dir?) (split-path (current-directory))])
    (format "v~a Software Patches" name)))

(import-from "../bundle-information.ss" plt-instructions)

(define plt-installing-trailer
  @span{
    @hr{}
    @(plt-instructions (void))
    @font[color: 'red]{
      @b{@i{Please remember to restart DrScheme after installing the @;
            package.}}}
    @hr{}})

(require version/utils)

(define patched-versions
  ;; list-of (version-string link)
  ;; delayed because it links to patch pages that use this file back
  (delay
    (let ([ps (parameterize ([current-directory
                              (this-expression-source-directory)])
                (filter-map (lambda (p)
                              (and (directory-exists? p)
                                   (let* ([s (path->string p)]
                                          [v (version->integer s)])
                                     (and v (cons v s)))))
                            (directory-list)))])
      (for/list ([d (sort ps < #:key car)])
        (list (cdr d) (link-to (format "/download/patches/~a/" (cdr d))))))))

(define (run)
  (write-tall-page (PLT title)
    @p{Patches are available for the following versions of PLT software.
       @(apply ul (map (lambda (v) @li{@(cadr v)})
                       (force patched-versions)))}))
