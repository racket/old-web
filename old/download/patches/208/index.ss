#reader"../../../common/html-script.ss"

(import-from "../" patch-title plt-installing-trailer)

(define title (patch-title))

(define (run)
  (write-tall-page (PLT title)
    @ul{@li{@a[href: "plt-208-p1.plt"]{PLT Scheme 208, patch 1}
            @br{}
            @ul{@li{The @tt{image.ss} teachpack and its documentation are
                    fixed.}
                @li{Added the design wizards that participants in the HtDCH
                    Java workshop used in conjunction with ProfessorJ.}
                @li{Improved PLaneT documentation.}}}}
    plt-installing-trailer))
