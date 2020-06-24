#reader"../../common/html-script.ss"

(define title "Software License")

(define (run)
  (write-tall-page (PLT title)
    @p{PLT software is distributed under the
       @a[href: "http://www.gnu.org/copyleft/lesser.html"]{
         GNU Lesser General Public License (LGPL)}.
       This means that you can link PLT software (such as @(link-to 'mzscheme)
       or @(link-to 'mred)) into proprietary applications, provided that you
       follow the specific rules stated in the LGPL.  You can also modify PLT
       software; if you distribute a modified version, you must distribute it
       under the terms of the LGPL, which in particular means that you must
       release the source code for the modified PLT software.}))
