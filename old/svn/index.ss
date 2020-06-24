#reader"../common/html-script.ss"

(define title "Subversion Repository")
(define link-title "Subversion")

(define (subsection . xs) (p (apply strong xs)))

(define (tt* . xs) (font color: 'green (apply tt xs)))

(define (submod n s) @splice{@tt*{@n}: @|nbsp nbsp s|})

(define (run)
  ;; these are the repositories
  (for-each writing/prefix '("plt" "iplt" "play"))
  (write-tall-page (PLT title) #:search 'source
    @p{The Subversion server provides access to the source code for PLT
       software (DrScheme, MzScheme, etc.) as it is being developed.  The
       server is useful for those who want access to the latest and greatest
       version of PLT software, either to take advantage of new features or to
       help test the new code.}
    @p{For a simple access to full nightly builds that does not require
       Subversion, see the nightly
       @a[href: (url 'pre-release-installers)]{pre-release installers page}.}
    @p{To use the Subversion server, you will need
       @ul{@li{Experience using the regular PLT release.}
           @li{One of the platforms with
               @a[href: (url "/pre/binaries/")]{pre-release binaries},
               or a C/C++ compiler:
               @ul{@li{Unix: most any compiler}
                   @li{Windows: MSVC (Express version is free from Microsoft)}
                   @li{Mac OS: gcc (OS X)}}}
           @li{@a[href: "http://subversion.tigris.org/"]{Subversion client}
               software (optional).}
           @li{Patience and proficiency for using unstable Scheme and C code.}}
       If you lack any of these, consider downloading compiled binaries or
       source code via the regular download page for @(link-to 'plt),
       @(link-to 'mzscheme), or @(link-to 'software).}
    @;;------------------------------------------------------------
    @section{Using the Repository}
    @p{The subversion repository is on this server, @tt*{@(url "plt")}.
       For reasonably stable code, always use the trunk, which is at
       @div[align: 'center]{
         @a[href: (url "plt/trunk/")]{@tt*{@(url "plt/trunk")}}.}}
    @p{The subversion repository is available in many different ways:
       @ul{@li{The simplest way is to just point your browser at this URL, and
               view the repository.}
           @li{If your operating system has the capability to mount "web
               folders", you can mount this URL, and get the repository as a
               plain directory.}
           @li{For more detailed information, you can use the
               @a[href: "view/trunk/"]{ViewVC interface} to the repository.}
           @li{Finally, using the
               @a[href: "http://subversion.tigris.org/"]{Subversion client},
               you can checkout the repository with the following command:
               @pre{  svn checkout @(url "plt/trunk") plt}
               (Make sure that you use "@tt*{trunk}", or you will get many
               copies of the whole tree.)}}}
    @;;------------------------------------------------------------
    @section{Repository Overview}
    @p{The PLT @tt*{trunk} contains the following directories:
       @ul{@li{@(submod "collects" "Scheme code, organized into collections")}
           @li{@(submod "man" "Unix man pages")}
           @li{@(submod "src" "C code")
               @ul{@li{@(submod "mac" "Mac code")}
                   @li{@(submod "mred" "MrEd code")}
                   @li{@(submod "worksp"
                                "Windows MSVC makefiles and projects")}
                   @li{@(submod "starter" "Windows program-launcher code")}
                   @li{@(submod "srpersist" "SrPersist code")}
                   @li{@(submod "mysterx" "Windows MysterX code")}
                   @li{@(submod "mzscheme" "MzScheme code")}
                   @li{@(submod "wxxt" "X MrEd code")}
                   @li{@(submod "wxwindow" "Windows MrEd code")}
                   @li{@(submod "wxmac" "Mac MrEd code")}
                   @li{@(submod "wxcommon" "MrEd code")}}}}
       Of course, when building under Windows (for example), the directories
       for Unix and Mac aren't needed.  Similarly, the MrEd or MysterX
       directories are not needed to build only MzScheme.}
    @;;------------------------------------------------------------
    @section{Building and Using the Code}
    @subsection{Building C Source}
    @p{Compilation information is provided by README files in various
       @tt*{plt/src} directories.  Start with @tt*{plt/src/README}.}
    @subsection{Downloading Pre-Release Binaries}
    @p{If a binary for your platform is available from
       @a[href: (url "/pre/binaries/")]{the pre-release binaries page}, then
       you can download the binaries instead of building them.  The pre-release
       binaries are updated nightly by building with the @tt*{trunk} code.}
    @p{For installation instructions, see the bottom of the pre-release
       download page for your platform.}
    @subsection{Updating Collection Files}
    @p{After building and/or installing the binaries, byte-code-compile the
       Scheme sources by running Setup PLT (@tt*{setup-plt} in Unix).  Whenever
       you update Scheme code in the @tt*{plt/collects} directory, run Setup
       PLT.}
    @;;------------------------------------------------------------
    @section{Change Logs}
    @p{The change logs can be found in @tt*{HISTORY} files within
       @tt*{plt/notes}. For example, @tt*{plt/notes/mzscheme/HISTORY} records
       the changes made to MzScheme.  Relatively detailed notes are kept
       between regular releases, but then collapsed when the release occurs.}
    @p{In addition, the @(link-to "/download/chronology/") page has all release
       announcements.}
    @;;------------------------------------------------------------
    @section{Version Numbering}
    @p{The version numbers for MzScheme and MrEd are always kept in sync.  A
       pre-release version number has the form N.M.P.Q, where N.M.P is usually
       the version number for the previous regular release, and Q indicates the Qth
       @tt*{trunk} version after the N.M.P release.  For example, 4.2.0.8 means
       "the 8th checkpoint after the release of version 4.2.0".}
    @p{The Scheme code implementing DrScheme evolves at its own pace, but does
       not have a version number, per se.  Instead, it uses the date of the
       checked out source for a reference.}
    @;;------------------------------------------------------------
    @section{Old Sources}
    @p{PLT Scheme used to be hosted on CVS, but has moved to Subversion.  The
       new repository does not contain the complete history, so the CVS
       repository is still active for historical content.}
    @subsection{Using the @font[color: 'red]{Old} Repository}
    @p{@ul{@li{Repository: @tt*{anoncvs.plt-scheme.org:/cvs}}
           @li{Pserver user: @tt*{anonymous}}
           @li{Password: @em{empty}}
           @li{Module: @tt*{plt}}
           @li{Tag for the last stable code in CVS: @tt*{exp}}}
       The following commands will checkout the last stable version in CVS:
       @pre{  cvs -d :pserver:anonymous@"@"anoncvs.plt-scheme.org:/cvs login}
       @pre{  <hit Enter at the password prompt>}
       @pre{  cvs -d :pserver:anonymous@"@"anoncvs.plt-scheme.org:/cvs @;
                   checkout -r exp plt}}))
