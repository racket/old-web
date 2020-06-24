#reader"../../../common/html-script.ss"

(import-from "../" patch-title plt-installing-trailer)

(define title (patch-title))

(define (run)
  (write-tall-page (PLT title)
    @ul{@li{@a[href: "drscheme.204.p1.plt"]{DrScheme patch 1}
            @br{}
            Fixes an error for drawing tail arrows.}}
    plt-installing-trailer))
