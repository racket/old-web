#reader"../common/html-script.ss"

(define title "About PLT Releases")

(define --- mdash)

(define (subsection . s)
  (p (apply strong s)))

(define (tech-key s)
  (regexp-replace #rx"s$" (string-downcase s) ""))

(define (deftech s)
  (a name: (tech-key s) (i s)))
(define (tech s)
  (a href: (format "#~a" (tech-key s)) s))

(define (run)
  (write-tall-page title
    @;;------------------------------------------------------------
    @section{Executive summary}
    @ul{@li{Commit to the SVN trunk when you want the world to use your code.
            Update tests and documentation every time that you commit code
            changes.}
        @li{A @tech{normal release} is branched from the SVN trunk on the 15th
            of every odd-numbered month.  Once it is created, the only changes
            to the branch are merges of bugfixes and release-related materials
            (like HISTORY files) @--- not new features.}}
    @;;------------------------------------------------------------
    @section{What is a normal release?}
    @p{A @deftech{normal release} is a bundle whose version number has no
       fourth sub-number, and one that we intend for all PLT Scheme users to
       download as soon as it becomes available.}
    @p{We also have @deftech{nightly builds}.  These builds always have a
       fourth number in their version, and they are built from the SVN trunk.
       They are also releases in the sense that we intend for a small (but
       significant) fraction of PLT Scheme users to switch daily (more or
       less).}
    @p{The quality demands for a normal release are higher than for a nightly
       build, because the audience is much wider.  Nevertheless, a nightly
       build has quality standards too.  Just keep in mind the implication of
       committing to the trunk: it's a signal that someone you don't know
       should run your code, read your docs, and expect it all to work (but
       they'll be a little forgiving if it's not quite right today and it's
       fixed tomorrow).}
    @p{During periods of major changes, we sometimes have an intermediate level
       of @deftech{alpha} releases, which have version numbers of the form
       "X.9y" or "X.Y.9zz".  These releases are used infrequently, usually
       before major changes.  (The availability and convenience of nightly
       builds diminishes the need for such alpha releases.)}
    @;;------------------------------------------------------------
    @section{When do we create a normal release?}
    @p{We create a normal release every two months.  The two-month schedule is
       a compromise between allowing improvements to flow into the release
       continuously versus the effort required for integration and system
       testing.}
    @p{We @strong{do not} create a normal release to push out a new feature.
       If you need a feature included in the normal release by a particular
       date, then plan ahead and have it in the SVN trunk for the preceding
       branch date (i.e., the 15th of some odd-numbered month).  (A reminder
       will be sent a week prior to the branch creation to allow people to
       prepare for the release in cases like this.)}
    @;;------------------------------------------------------------
    @section{Why distinguish normal releases from nightly builds?}
    @p{As our project has grown, the nightly-builds release has been crucial
       for getting normal releases out on a human timescale.  Since lots of
       people test the most recent code, things mostly work all the time.}
    @p{Nevertheless, to ensure a quality package for less forgiving users, we
       need to synchronize the point at which all developers have their most
       refined efforts in place. A release, then, is a synchronization point
       for integration and system testing.}
    @p{Note that the audience for a normal release can be very wide: it
       includes schools, labs, and people who use 3rd-party packages through
       their OS.}
    @;;------------------------------------------------------------
    @section{What is the relationship between a release and a set of features?}
    @p{Normal releases are driven by time, not by feature sets.  The features
       of a normal release are effectively frozen when the release branch is
       created.  Adding a feature after the branch date requires unanimous
       approval from @tech{management}, and the rules are set up to make such
       approval difficult.}
    @p{A normal release, then, is unrelated to the pressure for adding features
       or fixing bugs.  This pressure derives from external conditions and
       constraints, regardless of releases or version numbers: a feature that
       is useful for a class, your advisor requires that a feature is in
       publishable condition by some date, a company promises to send you a
       large check if you add a feature, or if you just want the world to
       experience your wonderful new invention.  Whatever the reason is, you
       need to manage your own schedule to make it to your own deadline.  In
       the absence of any other constraints then, you should not plan in terms
       of ``I want to add feature X, and it should be ready for version Y.''
       Implement feature X, take however long it takes, and deliver the results
       to nightly build users as soon as possible.}
    @p{The set of features in a release as compared to the previous normal
       release determines the version number: if a release has only bug fixes
       and minor feature changes from the previous release, then only the third
       number in the version changes.  Significant incompatibilities change the
       second number of the version.  The first version number changes only
       with major architectural changes.}
    @;;------------------------------------------------------------
    @section{How does release time differs from any other time?}
    @p{The period before a release should be a time of heightened testing and
       tweaking.  Mostly, it means performing the checklist of tasks that go
       with a release, but you should also keep an eye on anything else that
       looks suspicious (as an extreme example, if you run some code and get a
       segfault then don't just ignore and run it again).  Other than this, you
       can go about as usual in new developments on trunk.}
    @p{Note that testing, tweaking, and documentation polishing are
       @strong{not} release-only tasks@";" those happen all the time for the
       nightly build.}
    @p{As a release-branch date approaches, it really isn't a time for making
       up for months of late work and pushing a lot of new material out.  If
       you have a great new idea, you can still work on it and commit your
       progress to the trunk, but chances are very low that the idea should be
       in the release.  It's better to let the code mature for a while on the
       trunk @--- and have it included in the following release (which will
       happen soon anyway).}
    @p{Note that even minor changes can have surprising consequences for a
       project of PLT's scale.  Therefore, once the realease branch was
       created, please keep merge requests to bug fixes only.  Seriously.}
    @p{Sometimes, an existing piece of code isn't quite in place when the
       release starts @--- maybe you didn't get to finalize the work in time
       for the release branch.  In this case, ask for removing it from the
       release branch, effectively reversing commits that were included in it,
       or, if possible, provide a minimal patch to disable the new code.  This
       is likely a better option than fixing everything to work in the last
       minute.  If in doubt, raise your concern on the plt-internal list.}
    @;;------------------------------------------------------------
    @section{What should individuals do during release time?}
    @p{If you're on Eli's list to receive special reminders before a release
       @--- congratulations!  However, please keep in mind a few things:}
    @ul{@li{They're generally @strong{reminders} to make sure that things don't
            fall through the cracks, not a request to start working on
            something.  If you're responsible for testing or for some
            documents, you should be able to quickly respond that everything is
            fine, because you've been testing or writing all along (and you
            just checked or proofread one more time for good measure).}
        @li{Eli needs response relatively quickly.  Two days should be normal.
            In bad cases the release process can take a week when unexpected
            problems arise.  If you can't regularly respond on that time scale,
            then we need someone else to take over your job.  If you know
            you're going to be especially busy near a release (e.g., due to a
            paper deadline), then don't wait until you get the reminder to say
            you can't do it@";" we set a schedule in advance (15th of every
            odd-numbered month) so you can plan around such problems.}
        @li{Even if your tests are part of the nightly build (which is a very
            good idea) you should still run them.  This is because in some
            cases the nightly test suite can miss failures because the tests
            are not setup correctly (this @strong{has} happened).}
        @li{Keep an eye for any problems, and report anything that looks bad.
            Don't dismiss potential problems because ``they're not your
            problem''.}
        @li{If for some reason you needed to merge changes that could
            potentially interact with other parts of the distribution, then
            make sure to notify the list, so we can consider another quick
            round of tests.}}
    @p{Otherwise, your help is greatly appreciated in exercising parts of
       DrScheme that you don't normally use.  Note that you should be testing
       the release branches from the @tech{candidate build} @--- don't check
       out the release branch.  The intention is to try things out as users see
       them.}
    @;;------------------------------------------------------------
    @section{Rules for a normal release}
    @;;----------
    @subsection{Management}
    @p{PLT Scheme @deftech{management} runs the release. Current management is
       Matthias, Eli, Robby, and Matthew.}
    @;;----------
    @subsection{Timing and Branches}
    @p{There are six releases per year.  For each release, a branch is created
       in the repository to prepare the release.  The date at which the
       repository branch for each release is created is fixed: the 15th day of
       every odd-numbered month.  One week before each release (i.e., the 8th
       of each odd-numbered month), Eli will normally send a courtesy reminder
       of the upcoming branch.}
    @p{When a release branch is created, the version number is changed in both
       the trunk and the branch.  The branch release number is not the final
       number, but instead a @deftech{release candidate} version number (with
       four parts,where the last one is in the 900s).}
    @p{On occasion, a scheduled release may go out with a particularly bad bug
       that needs to be fixed before the next normal release.  Such
       intermediate releases will be based on a branch from the most recent
       normal release, and they may not require performing the entire release
       checklist.}
    @;;----------
    @subsection{Changing the Branch}
    @p{The content of a release is essentially whatever exists in the SVN trunk
       at the time that a branch for the release is created.}
    @p{If you happen to commit some changes just before the release and you
       don't want them to be included in the branch, e-mail Eli with the
       revision numbers to ``unmerge'' from the branch.}
    @p{Otherwise, changes to the branch for the actual release must be bug
       fixes.  To fix a bug, commit to the trunk and ask Eli to merge the
       change to the release branch.  This request is preferably communicated
       through the commit log message@";" otherwise, record the relevant
       revision number/s and email them.  When the release branch is updated, a
       new build will be made (at the same location).}
    @p{To include a new feature post-branch, you have to convince management
       that it's OK.  Management agrees to new features based on unanimous
       consent.  Past experience suggests that management will be picky about
       new features, and the unanimous-consent rule weighs heavily against new
       features.  If there's any question of whether a change is a ``bug fix''
       or a ``feature'', then it's a ``feature.''}
    @;;----------
    @subsection{Candidate Builds}
    @p{@deftech{Candidate builds} are created from the branch and announced on
       the plt-internal list.  Such builds are available at a ``hidden''
       location (not a secret one, but not in a regular place so it is not used
       by mistake).  Sometimes these builds will also be announced on the
       general plt-scheme mailing list, when we want to solicit wider testing.}
    @;;----------
    @subsection{Checklist Processing}
    @p{Within two days or so of the branch date, Eli sends out the
       @a[href: (url "/svn/iplt/trunk/misc/checklist")]{checklist} items.  Each
       checklist item has a specific person attached to it, and that person is
       responsible for completing the task within a few days (a week, at most)
       that the checklist goes out.}
    @p{Use the @tech{candidate build} for checklist processing, not the SVN
       trunk or release branch.}
    @;;----------
    @subsection{From Candidate to Release}
    @p{The time between the branch date and release date is used for extra
       testing, bug fixes, and release-checklist tasks.  Checklist tasks will
       generally require a total of a week between the branch and the actual
       release, but the actual delay is determined by management for each
       release.}
    @p{When the checklist is completed, an announcement message is composed,
       and the version number in the release branch is changed from the
       @tech{release candidate} number to the final number.  Finally, the
       release is made publicly available.}))
