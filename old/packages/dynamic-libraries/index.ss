#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "Dynamic Libraries")

(define blurb
  @`{Under Windows and Mac OS X, stand-alone executables built with older
     versions of PLT Scheme require a set of dynamic libraries.  Although the
     libraries are included with @(link-to 'plt), we also provide installers
     for just the libraries.})

;; These were needed in pre-350 versions, remove the blurb so its not on the
;; front download page
;; (define download-blurb
;;   @`{Windows and Mac OS X software created with PLT Scheme will require
;;      these libraries (included with @(link-to 'plt)).})

(define sys-req
  @system-requirements{
    @|windows-versions| or @|osx-versions|.  Installing the libraries requires
    roughly 3 MB of disk space.})

(define tag 'libs)
(define download-pages
  (make-download-pages tag title sys-req (concat "Download " title)))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{Under Windows and Mac OS X, stand-alone executables built with
       older versions of PLT Scheme (usually with @(link-to 'drscheme)) require
       a set of dynamic libraries.  Since version 350, distribution executables
       created by DrScheme include all dynamic libraries.}
    @p{The @a[href: (download-pages 'url)]{download} page provides installers
       for the dynamic libraries for version 301 and earlier.  If you build
       executables with version 301 or earlier, feel free to
       re-distribute the dynamic-library installers with your own applications,
       or direct users to our @a[href: (download-pages 'url)]{download}
       page.}))

(begin-page (download-pages 'path+title)
  (define (run) (download-pages 'run panel)))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@(link-to 'docs)}
       @list{Complete PLT documentation in a variety of formats.}))))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to 'drscheme)}
       @list{A programming environment for creating programs based on PLT
             Scheme.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{PLT Scheme is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #t))))
