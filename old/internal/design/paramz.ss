#reader"../../common/html-script.ss"

(define title "Parameterizations are Bad")

(define (run)
  (write-tall-page title
    @h2{Parameters are good}
    @p{We have used parameters as inheritable thread-local state to good
       effect:
       @ul{@li{for declaring large numbers of overrideable default parameters
               (e.g., pretty-print)@";"}
           @li{for maintaining security information over a hierarchy of threads
               (e.g., custodians)@";" and}
           @li{for interposing on key parts of the system (e.g., the evaluation
               handler).}}}
    @h2{Parameterizations are bad}
    @p{We have not used parameterizations with sharing to good effect.
       Instead, we suffer from the complexity that sharing imposes on our
       programs.}
    @h3{Sharing is complex}
    @p{Parameter-sharing across threads complicates local reasoning.  For
       example,
       @pre{(define (read-grade-list f)
              (with-input-from-file f read-grames-from-stdin))}
       @tt{read-grade-list} won't work in a setting where the current input
       port is shared with other threads. Is `read-grade-list' to blame?
       Should @tt{read-grade-list} be written
       @pre{(define (read-grade-list f)
              (with-parameterization (new-parameterization)
               (lambda ()
                 (with-input-from-file f read-grames-from-stdin))))}
       to protect against sharing? Or should the interface for
       @tt{read-grade-list} specify that it temporarily sets the input port, so
       clients must be careful?}
    @p{One could argue that a client should never make a parameter shared
       unless the client knows how the parameter is used everywhere. But some
       library code must defend against every possibility. For example,
       consider @tt{dynamic-disable-break}, a procedure within MzLib:
       @pre{(define (dynamic-disable-break thunk)
              (parameterize ([break-enabled #f])
                (thunk)))}
       If the calling thread shares the @tt{break-enabled} parameter with other
       threads, the above code can go wrong in various ways. Here's an
       attempt at a defensive version:
       @pre{(define (dynamic-disable-break thunk)
              (with-parameterization (new-parameterization)
               (lambda ()
                 (parameterize ([break-enabled #f])
                  (thunk)))))}
       No good@";" @tt{thunk} might depend on some sharing in the original
       parameterization. Should we sharing everything except
       @tt{break-enabled}?  Ok, but might @tt{thunk} actually rely on the
       sharing of @tt{break-enabled}?}
    @p{We have set up some rules, conventions, and documentation so that
       libraries procedures work well enough under certain conditions, but
       it's messy, and I doubt that the rules, conventions, and documentation
       are exhaustive. MzLib's @tt{dynamic-disable-break} matches the first of
       the above definitions@";" when I use @tt{dynamic-disable-break}, I
       sometimes added the defense code myself, which is reasonable because I
       know exactly what @tt{thunk} does in that context. But the resulting
       code is messy and error-prone.}
    @p{Sometimes the system needs to temporarily set the exception handler.
       The exception handler should not leak out to a client, otherwise a
       client can break invariants in the system. In this case, the system is
       forced to create a temporary parameterization. Again, the code is
       messy and error-prone.}
    @h3{We don't need sharing}
    @p{I grepped for @tt{make-parameter-with-sharing} in plt/collects and found
       exactly one use: a initialization in DrScheme that shares everything
       except the exception handler.}
    @p{I happen to know that this use of @tt{make-parameter-with-sharing} caused
       Robby weeks of trouble, and I suspect that it was responsible in some
       part for the reading/breaking bugs that persisted in DrScheme 53. The
       sharing was it was too hard to reason about, and bug after bug turned
       out to be caused by unexpected sharing. Last I knew, Robby planned to
       get rid of sharing-by-default in DrScheme's implementation, but
       parameterizations led him astray and we lost a lot of time.}
    @p{In the past, there have been other uses of parameter-sharing. Indeed,
       parameterizations were not invented in a vaccuum; they were designed
       to solve specific problems. But over time, we found that sharing was
       not the right solution for those other problems.}
    @p{It seems likely that DrScheme needs some sort of sharing that goes
       through parameters, but that sharing can be made explicit, using boxes
       or mutable structures/objects. This alternatives will fail only if
       some third party needs to make the decision about where sharing
       occurs@";" I do not believe that is the case.}
    @p{My @tt{make-parameter-with-sharing} grep cannot locate sharing where two
       threads use the same parameterization. Looking at our code, I didn't
       find any of that kind of sharing@";" I'm fairly certain I don't use it,
       and I think that anyone who tried to use such sharing would run into
       the same problems as Robby (or, just as likely, the code is broken but
       no one has noticed - yet).}
    @h3{MzScheme without parameterizations}
    @p{Although parameterizations were an interesting design experiment, I
       belive that they're a failure, and we should discuss removing them
       from MzScheme. Without parameterizations, parameter values would be
       thread-specific@";" a new thread's parameter values would be initialized
       with the creating thread's values.}
    @p{Most of our code would become more reliable and understandable without
       any changes (i.e., existing uses of @tt{parameterize} would never go awry
       due to unexpected sharing). In some places, we initialize a
       parameterization before creating a thread, or we initialize the
       parameterization of an eventspace, but I think we can rearrange such
       code to put the initialization within the created
       thread/eventspace. [In 53, an eventspace might have multiple handler
       threads, so we needed a persistent parameterization separate from the
       threads. In 100, each eventspace has a single handler thread, and we
       can use high-priority callbacks to initialize parameter values in that
       thread.]}
    @p{In some places, parameterizations are not intended for sharing, but
       instead to temporarily install a large set of parameter values (e.g.,
       when user code calls display routines handled by DrScheme code). Such
       uses of parameterizations might accidentally share parameters across
       threads.  We must look at the code to see whether procedures of the
       form
       @pre{(define (with-xxx-parameterizations thunk)
              (parameterize ([param1 ...]
                             [param2 ...])
                (thunk)))}
       provide an equivalent (or better) solution.}
    @h3{Philosophical benefits to dropping parameterizations}
    @p{Can a third party ever make good decisions about parameter sharing
       within opaque components? The idea of letting the third party choose
       has always seemed questionable, and I have struggled to find examples
       where a third party needs control. I don't think I ever found a
       compelling example (including the one in my ESOP submission). Whetever
       examples there may be, our experience suggests that they are too few
       and far between to justify the complexity that parameterizations
       impose on the rest of the system.}
    @p{Parameters have been most valuable in DrScheme as a security
       mechanism.  Where Java plays fancy games with the stack, we use
       parameters, and unlike Java's security mechanism, parameters work with
       tail-recursion. By removing the possibility of unexpected sharing, we
       make parameters a suitable vehicle for replacing Java's current
       security protocol.}
    @hr{}
    @i{Matthew Flatt@br{}Thu Feb 11 08:08:49 CST 1999}))
