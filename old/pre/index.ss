#reader"../common/html-script.ss"

;; This hierarchy creates skeleton files that are later plugged by the build
;; script

(define (hole tag)
  @literal{

    <!-- begin: __@|tag|__ -->
    @tag
    <!-- end: __@|tag|__ -->

    })

(define content-hole (hole "CONTENT"))

(define version-hole @div[align: 'right]{@small{@i{@(hole "VERSION")}}})

(define pre-release-hubs
  #f
  #;
  `(((b () "Pre-Release") pre-release-top)
    ("Installers"         pre-release-installers)
    ("Documentation"      pre-release-docs)
    ("Subversion"         "/svn/")
    ;; ("Search"             pre-release-search)
    ("Chronology"         "/download/chronology/")))

(define title "Nightly Builds")

(define (run)
  ;; this is where the build tree is copied to
  (writing "plt/")
  (write-tall-page (PLT title) #:search 'source
    @p{This directory contains PLT material that is built daily from the
       repository.  See below for instructions.}
    @hr{}
    content-hole
    @hr{}
    @p{The nightly-builds page is being built every night from the current
       @a[href: (url "/svn/")]{Subversion repository}.  This makes it possible
       to use the latest material with close to zero hassle that is normally
       associated with checking out the development tree.  You can choose
       whether you want to use the full source tree, which means that you will
       get a lot more than you get with a standard distribution, or the
       installers that contain the same material as a standard distribution.}
    @p{For the easiest way of getting a build, choose an installer for your
       platform from the @a[href: (url "installers/")]{@tt{installers}}
       directory.}
    @p{For an approach that is more suitable for scripting, you should:
       @ol{@li{start at the @a[href: (url "binaries/")]{@tt{binaries}}
               subdirectory for your platform,}
           @li{download the @tt{plt-...-full.tgz} file,}
           @li{unpack it with GNU Tar (or something compatible to it), for
               example: "@tt{tar xzf plt-...-full.tgz}"}
           @li{Mac OSX users need to get the
               @tt{plt-ppc-osx-mac-frameworks.tgz} (or @tt{plt-i386-osx-}...)
               and unpack it at the right place (this will not overwrite other
               installed PLT versions).}
           @li{run "@tt{./install -i}" (or "@tt{install.bat}" on Windows).}}
       Note that there are many other `@tt{tgz}' files that contain various
       subsets of the tree, for example, you can get just the documentation
       part, the clean @tt{plt/src} part, the full tree before any compilation,
       documentation @tt{.plt} files, or for each platform a @tt{tgz} file that
       contains just native-code binary files.}
    @p{It is also easy to setup a script that will automate the process of
       retrieving the @tt{tgz} file, unpacking and installing it.  This is
       explained in more details in @(link-to "script.html").  In addition to
       being convenient for updating your tree, it can be used by an automatic
       job scheduler (for example, a cron job on Unix) to make tree that is
       always updated.}
    @hr{}
    version-hole))
