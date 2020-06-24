#reader"../../../common/html-script.ss"

(import-from "../" patch-title plt-installing-trailer)

(define title (patch-title))

(define (run)
  (write-tall-page (PLT title)
    @ul{@li{@a[href: "profjWizard.plt"]{ProfessorJ Wizard for PLT Scheme 209}
            @br{}
            The @b{@i{ProfessorJ Wizard}} library was mistakingly omitted from
            the v209 distribution.  This is not actually a patch file:
            installing it will not change DrScheme, it will only add the
            missing library.}}
    plt-installing-trailer))
