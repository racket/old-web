#reader"../../../common/html-script.ss"

(import-from "../" patch-title plt-installing-trailer)

(define title (patch-title))

(define (run)
  (write-tall-page (PLT title)
    @ul{@li{@a[href: "v370p1.plt"]{First Patch for DrScheme 370}
            @br{}
            This patch fixes two bugs:
            @ul{@li{teachpacks that contain inline images now work properly,}
                @li{DrScheme's REPL's pict printer now signals errors with
                    proper source location when the pict's drawing has a
                    runtime error (instead of locking up the drscheme
                    window).}}}
        @li{@a[href: "v370p2.plt"]{Second Patch for DrScheme 370}
            @br{}
            This patch fixes two bugs:
            @ul{@li{Autosaving, when using the teaching languages, would signal
                    an error, but not anymore.}
                @li{Sometimes, clicking on the popup menu in the bottom right
                    would trigger an internal error. That's now fixed.}}
            @b{@i{Note:}} this patch includes the first patch above.}}
    plt-installing-trailer))
