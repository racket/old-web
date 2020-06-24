#reader"../../common/html-script.ss"

(import-from "/download/bundle-information.ss" make-download-pages)

(define title "MzScheme")

(define blurb
  @`{MzScheme is the underlying text-only implementation: it provides all of
     MrEd's features except the graphics library and the eventspaces.  Its
     language offers several extensions to standard Scheme.  The MzScheme
     executable is relatively small and loads quickly, and is designed to be
     used as an engine for executing scripts.  @,em{Unless you need the
       restricted interaction mode, we recommend that you use
       @(link-to 'drscheme).}  MzScheme is distributed
     @,a[href: (url "/download/mzscheme/")]{by itself} and as part of
     @,(link-to 'plt).})

(define download-blurb
  @`{The text-only PLT Scheme implementation (included with @(link-to 'plt)).})

(define sys-req
  @system-requirements{
    @windows-versions, @osx-versions, Unix, or standard x86 hardware.  The
    latest version of MzScheme is useful given at least 5 MB of RAM, and
    installing requires roughly 20 MB of disk space.})

(define tag 'mz)
(define download-pages
  (make-download-pages tag title sys-req (concat "Download " title)))

(define panel (make-panel title this-html-name))

(define (run)
  (write-panel-page panel title #:navkey 'download
    @p{@b{MzScheme} is the name of the core virtual machine for
       @(link-to 'plt).}
    @p{The @a[href: (url "/download/mzscheme/")]{MzScheme package}
       is a subset of the PLT Scheme package; 
       it contains MzScheme and console applications based on it, 
       including the PLT web server, but not including docs or GUI applications.}))

(begin-page (download-pages 'path+title)
  (define (run) (download-pages 'run panel)))

(begin-page "docs.html"
  (define title "Documentation")
  (define (run)
    (write-panel-page panel title #:search 'docs #:navkey 'download
      (panel-menu
       @list{@i{@a[href: (url "/download/doc/reference/")]{
                  Reference: PLT Scheme}}}
       @list{The online version of the MzScheme manual.}
       @list{@i{@a[href: (url "/download/doc/insidemz/")]{
                  Inside PLT MzScheme}}}
       @list{Describes how to extend or embed MzScheme in other applications.}
       @list{@(link-to 'docs)}
       @list{Complete PLT documentation in a variety of formats.}
       @list{@(link-to 'cookbook)}
       cookbook-desc))))

(begin-page "software.html"
  (define title "More Software")
  (define (run)
    (write-panel-page panel title #:navkey 'download
      (panel-menu
       @list{@(link-to 'planet)}
       planet-desc
       @list{@(link-to 'drscheme)}
       @list{A programming environment for creating MzScheme programs.}
       @list{@(link-to 'mred)}
       @list{Extends MzScheme with a portable GUI toolkit.}
       @list{@(link-to 'mzc)}
       @list{A Scheme-to-C compiler that is distributed with MzScheme.}
       @list{@(link-to 'software)}
       @list{More software from PLT.}
       @list{@(link-to 'license)}
       @list{MzScheme is LGPL software.}))))

(begin-page "support.html"
  (define title "Support")
  (define (run)
    (write-panel-page panel title #:navkey 'download (standard-support))))

(begin-page "learning.html"
  (define title "Learning")
  (define (run)
    (write-panel-page panel title #:search 'learn #:navkey 'download
      (standard-learning #t))))
