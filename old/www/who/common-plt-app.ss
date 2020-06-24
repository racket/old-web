#reader"../../common/html-script.ss"

(define (box-style border-width color)
  @concat{border: @|border-width|px solid black; @;
          padding: 5px; @;
          background: @color;})

(define title "Graduate Study with PLT")

(define (run)
  (write-tall-page title
    @h1{@title}
    @p{An open letter to graduate applicants:}
    @div[style: (box-style 3 "#ddd")]{
      @p{Dear Prospective Graduate Student,
         @br{}@br{}
         Thank you for your interest in working with PLT.  We get several
         inquiries every year from students interested in working with one or
         more of us.  We're flattered and, of course, interested in your
         applications.  Because you are more interested in PLT than in our
         specific institutions, we have created the following common
         application form.  By filling it in once, you can automatically apply
         to all current PLT institutions.}
      @p[style: (box-style 1 "#bbb")]{
         Yes, we know you don't like Boston/Chicago/Providence/Provo/Salt Lake
         City/San Luis Obispo/Worcester (circle those applicable).  But we like them, or we
         wouldn't be living there.  Think about the message you're sending by
         rejecting our choices.  Moreover, we think very highly of our
         colleagues@|mdash|more highly than we think of your judgment in this
         matter@|mdash|so for your own good, we're going to forward your
         application to them anyway.}
      @p{How many years have you programmed in Scheme?}
      @p{How many years have you programmed in PLT Scheme?}
      @p{If the two numbers above are not identical, justify.}
      @p{How many PLT Scheme Web applications have you written?}
      @p{What problems did you find with the PLT Scheme Web server in the
         process?  Please list bug report numbers.}
      @p{Which wheels did you inadvertently reinvent?}
      @p{Do you prefer your calculi Classic or Featherweight?}
      @p{Should types be intervals or ideals?}
      @p{In your opinion, which Barendregt proof has the highest hours spent
         understanding-to-symbols ratio?}
      @p{Which is your favorite combinator?}
      @p{Thank you for your interest.  Don't be a cat squandering the popcorn.}
      @p[align: 'right]{@|mdash|Shriram, Outreach Coordinator, PLT}}
    @p{Seriously, we @em{do} enjoy working with graduate students.  If you
       are inspired by the PLT project and want to drive the next generation of
       innovation, you should strongly consider graduate study with us.  We
       look forward to hearing from you.  All of us, no matter where we may
       live.}
    @p[align: 'right]{
      @|mdash|@;
      @a[href: "http://www.ccs.neu.edu/home/matthias/"]{Matthias},
      @a[href: "http://www.eecs.northwestern.edu/~robby/"]{Robby},
      @a[href: "http://www.cs.wpi.edu/~kfisler/"]{Kathi},
      @a[href: "http://www.cs.utah.edu/~mflatt/"]{Matthew},
      @a[href: "http://www.cs.brown.edu/~sk/"]{Shriram}}))
