#lang at-exp s-exp "shared.ss"

(require "common.ss")

(define/provide index
  (page #:title "About"
    (define (3panes left right bottom)
      (table cellpadding: 0 cellspacing: 0 border: 0
        (tr (td (div style: "margin-right: 30px;" left)) (td right))
        (tr (td align: 'center colspan: 2 bottom))))
    (3panes
     (list
      (parlist
       @text{@strong{PLT Scheme} is an innovative programming language that
         builds on a rich academic and practical tradition.}
       @text{It is suitable for implementation tasks ranging from scripting to
         application development, including GUIs, web services, etc.}
       @text{It includes the DrScheme programming environment, a virtual machine
         with a just-in-time compiler, tools for creating stand-alone
         executables, the PLT Scheme web server, extensive libraries,
         documentation for both beginners and experts, and more.}
       @text{It supports the creation of new programming languages through a
         rich, expressive syntax system. Example languages include Typed
         Scheme, ACL2, FrTime, Lazy Scheme, and ProfessorJ (which is a
         pedagogical dialect of Java).})
      (apply parlist @text{Getting started:} intros))
     (div class: "nolinkunderlines" style: "text-align: center;"
       (map p (list download-plt screenshots tour-video)))
     @p{Latest release: 4.2.5, April 2010} ;!!!
     )))

(define screenshots
  (let ([image (copyfile (in-here "screenshot.jpg") "screenshot.jpg")])
    @a[href: "http://plt-scheme.org/screenshots/"]{
      @img[src: image alt: "[screenshots]" border: 0
           style: "margin-bottom: 2px;"]@;
      @|br|@small{Screenshots}}))

(define tour-video
  (page #:title "DrScheme Tour" #:file "tour.html"
    (define (center . body)
      (table align: 'center style: "margin: 3em 0em;"
        (tr (td align: 'center body))))
    ;; someone posted a comment saying that adding "&fmt=18" to the url shows a
    ;; higher resolution video, but it looks exactly the same.
    (define url "http://www.youtube.com/v/vgQO_kHl39g&hl=en")
    @center{
      @object[type: "application/x-shockwave-flash"
              data: url width: (round (* 3/2 425)) height: (round (* 3/2 344))]{
        @param[name: "movie" value: url]}}))

(define download-plt
  (let ([img1 (copyfile (in-here "download.png") "download.png")]
        [img2 (copyfile (in-here "download-dark.png") "download-dark.png")])
    (list
     @script/inline[type: "text/javascript"]{
       @; Don't load all images here -- it causes a delay when loading the page
       @; instead, do it only when needed, and also set a timer to do it after
       @; loading the page.  This makes it so that there's almost never a delay
       @; when loading the page, and also no delay when switching the image.
       var rollovers = false, the_download_button = false;
       function init_rollovers() {
         if (!rollovers) {
           rollovers = [ new Image(), new Image() ];
           rollovers[0].src = "@img1";
           rollovers[1].src = "@img2";
           the_download_button = document.getElementById("download_button");
         }
       }
       function set_download_image(n) {
         if (!rollovers) init_rollovers();
         the_download_button.src = rollovers[n].src;
       }
       setTimeout(init_rollovers, 400);
     }
     @a[href: "http://download.plt-scheme.org/drscheme/"
        onmouseover: "set_download_image(1);"
        onmouseout: "set_download_image(0);"]{
       @img[id: "download_button" border: "0" src: img1
            alt: "Download PLT Scheme" title: "Download PLT Scheme"]})))
