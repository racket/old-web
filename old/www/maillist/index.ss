#reader"../../common/html-script.ss"

(define title "Mailing Lists")
(define blurb
  @'{We have two mailing lists: one strictly for announcements, and one for
     discussion.})

(define announce-archive-url
  "http://list.cs.brown.edu/pipermail/plt-announce/")
(define announce-email "plt-announce@list.cs.brown.edu")
(define announce-url "http://list.cs.brown.edu/mailman/listinfo/plt-announce/")
(define announce-request-email "plt-announce-request@list.cs.brown.edu")

(define list-url "http://list.cs.brown.edu/mailman/listinfo/plt-scheme/")
(define list-archive-url "http://list.cs.brown.edu/pipermail/plt-scheme/")
(define list-email "plt-scheme@list.cs.brown.edu")
(define list-request-email "plt-scheme-request@list.cs.brown.edu")
(define old-list-url "http://www.cs.utah.edu/plt/mailarch/")

(define devlist-url "http://list.cs.brown.edu/mailman/listinfo/plt-dev/")
(define devlist-archive-url "http://list.cs.brown.edu/pipermail/plt-dev/")
(define devlist-email "plt-scheme@list.cs.brown.edu")
(define devlist-request-email "plt-scheme-request@list.cs.brown.edu")

(define (gmane-url n) (format "http://dir.gmane.org/gmane.lisp.scheme.plt~a" n))
(define google-url "http://groups.google.com/group/plt-scheme")

(define (run)
  (write-tall-page (PLT title)
    @p{(@a[href: (url "espanol.html")]{
          Listas de Correo en Espa@|'ntilde|ol})}
    @br{}
    @p{We have three main English-language mailing lists: one strictly for
       announcements, one for general discussions, and one for developers.}
    @section{Low-Volume Announcement-Only List}
    @p{The announcement-only list has a
       @a[href: announce-archive-url]{Web archive}.}
    @p{Our announcement-only list is intended for people who need to track
       releases and important patches but don't wish to participate in
       discussions.  The list is moderated to avoid irrelevant posts.
       The volume is extremely low@|mdash|only a handful of messages a year.
       Ideal for systems administrators!}
    @p{To subscribe to @code{@announce-email} visit the Web page
       @blockquote{@code{@a[href: announce-url]{@announce-url}}}
       or send email to
       @blockquote{@code{@announce-request-email}}
       with the word `help' in the subject or body of the message.  You'll get
       back a message with instructions.}
    @section{Discussion List}
    @p{The discussion list has a @a[href: list-archive-url]{Web archive}.
       (Messages before 2002-06-13 are in an
       @a[href: old-list-url]{older archive}.)}
    @p{If you have problems with installation, or questions about using PLT
       Scheme (please don't post your homework questions!), send mail to the
       list at
       @blockquote{@code{@list-email}}
       To send a message to the list you need to subscribe@|mdash|please do
       so by directing your browser at
       @blockquote{@code{@a[href: list-url]{@list-url}}}
       or send an email to
       @blockquote{@code{@list-request-email}}
       with the word `help' in the subject or the body of the message.
       You'll get back a message with instructions.}
    @p{The list is also viewable and searchable through Gmane,
       @blockquote{@code{@a[href: (gmane-url "")]{@(gmane-url "")}}}
       and through Google Groups,
       @blockquote{@code{@a[href: google-url]{@google-url}}}
       Both offer additional ways of using it: via HTML, as an RSS feed, or
       as a newsgroup.}
    @section{Developers List}
    @p{The developers mailing list is intended for discussions about the
       development of PLT Scheme itself.  This is not the place to ask
       questions about using PLT Scheme, use the above mailing list for this.}
    @p{Use
       @blockquote{@code{@a[href: devlist-url]{@devlist-url}}}
       or
       @blockquote{@code{@devlist-request-email}}
       to subscribe to this list.  Archives are available at
       @blockquote{@code{@a[href: devlist-archive-url]{@devlist-archive-url}}}
       This list is also mirrord on Gmane, as
       @blockquote{
         @code{@a[href: (gmane-url ".devel")]{@(gmane-url ".devel")}}}}))
