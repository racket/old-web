#reader"../../common/html-script.ss"

(define title "Sites and People")

(define places
  (apply ul (map (lambda (p)
                   (let-values ([(place-name place-url person-name person-url)
                                 (apply values p)])
                     @li{@a[href: place-url]{@place-name}}))
                 '(("Brown University, Providence, RI"
                    "http://www.cs.brown.edu/research/plt/"
                    "Shriram Krishnamurthi"
                    "http://www.cs.brown.edu/~sk/")
                   ("Brigham Young University, Provo, UT"
                    "http://faculty.cs.byu.edu/~jay/"
                    "Jay McCarthy"
                    "http://faculty.cs.byu.edu/~jay/")
                   ("California Polytechnic State University, San Luis Obispo, CA"
                    "http://users.csc.calpoly.edu/~clements/"
                    "John Clements"
                    "http://users.csc.calpoly.edu/~clements/")
                   ("Northeastern University, Boston, MA"
                    "http://www.ccs.neu.edu/scheme/"
                    "Matthias Felleisen"
                    "http://www.ccs.neu.edu/home/matthias/")
                   ("Northwestern University, Evanston, IL"
                    "http://plt.eecs.northwestern.edu/"
                    "Robert Bruce Findler"
                    "http://www.eecs.northwestern.edu/~robby/")
                   ("University of Utah, Salt Lake City, UT"
                    "http://www.cs.utah.edu/plt/"
                    "Matthew Flatt"
                    "http://www.cs.utah.edu/~mflatt/")
                   ("Worcester Polytechnic Institute"
                    "http://web.cs.wpi.edu/~kfisler/"
                    "Kathi Fisler"
                    "http://web.cs.wpi.edu/~kfisler/")))))

(define (run)
  (write-tall-page (PLT title) #:search 'academic
    @p{PLT consists of numerous people distributed across several different
       universities in the USA: @places}
    @h4{Affiliates}
    @p{We work with
       @ul{@li{Dorai Sitaram, GTE Labs}
           @li{Francisco Solsona, Universidad Nacional Aut@|'oacute|noma de
               M@|'eacute|xico}
           @li{Mike Sperber, Universit@|'auml|t T@|'uuml|bingen}
           @li{Noel Welsh, LShift}}
       In particular, please check out the PLT-related work being done at
       @(link-to 'schematics).}
    @h4{And ...}
    @p{Finally, PLT is supported by an band of volunteers who contribute not
       only code and documentation but also infectious enthusiasm@|mdash|too
       many to name but whose help and encouragement make this fun and
       worthwhile.}))
