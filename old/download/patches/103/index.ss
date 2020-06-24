#reader"../../../common/html-script.ss"

(import-from "../" patch-title)

(define title (patch-title))

(define (run)
  (write-tall-page (PLT title)
    @p{The original downloads for MrSpidey, MysterX, and MzCOM
       have been updated since the original v103 release.}
    @p{Please use the download pages for those packages to
       obtain the current packages:}
    @ul{@li{@(link-to "/packages/mrspidey/")}
        @li{@(link-to "/packages/mysterx/")}
        @li{@(link-to "/packages/mzcom/")}}))
