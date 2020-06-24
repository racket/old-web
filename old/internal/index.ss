#reader"../common/html-script.ss"

(define title "PLT Internal")

(define (run)
  (create-filelink "current-build-log.txt" "/home/scheme/build-log.txt")
  (create-filelink "irc-logs" "/home/scheme/irc-logs")
  (write-tall-page title
    @ul{@li{@(link-to "design/")}
        @li{@(link-to "bugs/")}
        @li{@(link-to "mail.html")}
        @li{@a[href: "passwd/"]{PLT Passwords}}
        @li{@(link-to "svn.html")}
        @li{@(link-to "release.html")}
        @li{@(link-to "responsible.html")}
        @li{@a[href: (concat "http://list.cs.brown.edu/mailman"
                             "/listinfo/plt-internal/")]{
              @tt{plt-internal} (aka plt-design) mailing list}}
        @li{@(link-to "servers.html")}
        @li{@(link-to 'pre-release-top) (if a build fails, or if you want to
            follow a currently-happening build, you can look at the
            @a[href: (url "current-build-log.txt")]{current build log})}
        @li{@a[href: (url "irc-logs")]{IRC logs}}
        @li{Install a @a[href: "plt-ca.crt"]{certificate authority}
            to trust this site}}))
