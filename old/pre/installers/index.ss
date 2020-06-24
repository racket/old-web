#reader"../../common/html-script.ss"

(import-from "../" content-hole version-hole)

(define title "Download Pre-Release Software")

(define (make-one-page file extra)
  (write-tall-page* file title #:search 'source
    @p{Pre-release software is built using actively developed sources.
       Binaries are built nightly, and minute-by-minute changes are available
       through Subversion.}
    ;; ----------------------------------------
    @section{Option 1: Installer}
    content-hole
    version-hole
    extra
    @p{@table[width: "80%" align: 'center]{
         @tr{@td[valign: 'top]{Installers:}
             @td{@nbsp}
             @td{@dl{@dt{@b{PLT Scheme}}
                     @dd{Same as the normal distribution, containing the basic
                         systems (MzScheme, MrEd, and various libraries), and
                         DrScheme.}
                     @dt{@b{MzScheme}}
                     @dd{A small distribution that contains only MzScheme and
                         console applications based on it, including the PLT
                         web server.  No docs and no GUI applications.}
                     @dt{@b{PLT Scheme Full Repository}}
                     @dd{Contains the @i{complete} PLT tree from Subversion,
                         including full documentation, full source tree,
                         libraries that are not completely stable, and esoteric
                         material.}}}}
         @tr{@td[colspan: 3]{
               Note: the default installation directory contains the version
               number to avoid clobbering a normal installation.
               @small{Under Windows, registry names are different, too.}}}}}
    ;; ----------------------------------------
    @section{Option 2: Subversion}
    @p{Full source is available from our
       @a[href: (url "/svn/")]{Subversion}.}
    ;; ----------------------------------------
    @section{Option 3: Other}
    @p{Want Scheme sources from Subversion but don't want to build binaries?
       Want to browse a Subversion checkout? The
       @a[href: (url 'pre-release-top)]{nightly build page} has everything you
       could want.}))

(define (run)
  (make-one-page this-html-name
    ;; Don't use (url "table.html"), since the build can go into a
    ;; temporary directory -- so keep it a relative link instead of
    ;; the usual absolute links.
    @div[align: 'right]{
      @small{(@a[href: "table.html"]{No Javascript?})}}))

(void (begin-page "table.html" (make-one-page this-html-name "")))
