#reader"../common/html-script.ss"

(define title "PLT Mail via Gmail")

(define (run)
  (write-tall-page title
    @p{Electronic mail for @tt{plt-scheme.org} is used for easy use of the
       bug-report system, and for a simple Subversion setup: if a commit is
       done by @tt{foo}, then you can email @tt{foo@"@"plt-scheme.org} and
       reach the committer (and this is used by several hook scripts).  The
       email is handled by the new
       @a[href: "https://www.google.com/hosted"]{Gmail for Your Domain}
       beta service from Google.  This means that your
       @tt{foo@"@"plt-scheme.org} email account is serviced by Gmail.  The
       standard setup that you can use is to forward all
       @tt{foo@"@"plt-scheme.org} email to your real account: you will get
       emails that you expect to get, and you'll still enjoy Gmail's spam
       protection.  Of course you can also setup and use your
       @tt{foo@"@"plt-scheme.org} account as an ordinary Gmail account, with
       the usual gadgets that come with it (if you haven't used Gmail and
       wondered how it looks like, this is your chance to play with it).}
    @ul{@li{@a[href: "https://mail.google.com/hosted/plt-scheme.org/"]{Log-in}
            to your @tt{@"@"plt-scheme.org} email.}
        @br{}@br{}
        @li{@a[href: "https://www.google.com/hosted/plt-scheme.org/"]{Manage}
            the @tt{@"@"plt-scheme.org} domain (for the administrator).}}))
