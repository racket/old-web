#reader"../../../common/html-script.ss"

(import-from "../" patch-title plt-installing-trailer)

(define title (patch-title))

(define (run)
  (write-tall-page (PLT title)
    @ul{@li{@a[href: "360p1.patch"]{Patch for MrEd on Unix/X}
            @br{}
            This patch fixes a bug in MrEd for Unix/X.  The bug is exposed when
            using version 1.1 of @tt{libx11} (which is the version included
            with Ubuntu Feisty Fawn, for example).  Specifically, DrScheme and
            other MrEd-based programs would fail as soon as a mouse button is
            clicked or a key was pressed.}}
    @hr{}
    @p{This patch is for Unix/X only, you do not need it on other platforms.}
    @p{The file is a standard patch file for a source file in MrEd.  To use it,
       you will need a PLT tree that includes the source code, as well as the
       tools to compile PLT Scheme.  Apply the patch with:
       @pre{  cd ...@i{root-of-plt-tree}...
              patch -p0 < .../360p1.patch}
       and then rebuild your installation.}
    @hr{}))
