#reader"../common/html-script.ss"

(define title "Subversion Repository")

(define styles `((style ((type "text/css"))
                   "\n"
                   ".cmd {\n"
                   "  color: black;\n"
                   "  background: #eeeeee;\n"
                   "  border: #dddddd solid 1px;\n"
                   "  padding: 0.4em 1em;\n"
                   "  text-align: left;\n"
                   "  width: 80%;\n"
                   "  display: table;\n"
                   "}\n")))

(define (cmd . text)
  ;; (table align: 'center cellspacing: 0 cellpadding: 0
  ;;   (tr (td (br) (apply pre class: 'cmd text))))
  (div align: 'center (apply pre class: 'cmd text)))

(define (svnurl . text) (apply concat (url "/svn/") text))

(define --- mdash)

(define (subsection . body) (p (apply strong body)))

(define (run)
  (write-tall-page title #:head-stuff styles
    @p{The Subversion repository is based at @tt{@(svnurl)}}
    @;;------------------------------------------------------------
    @section{Quick Links}
    (let ([repos-list '("plt" "iplt" "play")]
          [sep '(td () nbsp nbsp nbsp nbsp)])
      (define (row repos)
        (define (link ref)
          (let ([ref (svnurl repos"/"ref)])
            @a[href: ref]{@tt{@ref}}))
        @tr{@td[align: 'right]{@tt{@repos}}
            @sep @td{@(link "")}
            @sep @td{@(link "trunk/")}})
      (apply table align: 'center cellspacing: 4
        @tr{@th{repos}@|sep|@th{base URL}@|sep|@th{main trunk}}
        (map row repos-list)))
    @div[align: 'center]{
      Also available as @tt{https://} URLs (helpful in some cases like
      restrictive web configuration or proxy, sensitive files).
      @br{}
      See also: a convenient @a[href: (svnurl "view/")]{ViewVC interface} for
      the @tt{plt} repository (not for the others).}
    @p{These links can be used with the "@tt{svn}" command-line tool, with a
       browser, or as a mounted web filesystem if your OS has that capability.
       @br{}
       @small{(Note: in theory it should be possible to write to a mounted web
              directory, but if you manage to do it then every write will
              create a new (autoversioned) commit.  If you want to try it out,
              use the @tt{play} repository where it is enabled.)}}
    @;;------------------------------------------------------------
    @section{Repositories and Layout}
    @p{There are four repositories:
       @ul{@li{"@tt{plt}": the main repository; world-readable and
               password-writable.}
           @li{"@tt{iplt}": internal repository@";" password accessible.}
           @li{"@tt{play}": similar to iplt, but intended for trying things out
               with Subversion; it is password protected, and it also has
               "auto versioning" (see below).}
           @li{"@tt{usr}": repository for private user-specific stuff.}}}
    @p{Each of the repositories except for the last one has a conventional
       Subversion structure, with @tt{trunk} as the main tree, @tt{tags} and
       @tt{branches}.  Note that for the @tt{plt} repository, the @tt{trunk} is
       the stable version that people are expected to use.  Also, the @tt{plt}
       repository has a toplevel @tt{graveyard} directory that contains
       unmaintained material (which could be moved to the trunk if something is
       resurrected).}
    @div[align: 'center]{
      @b{The trunk is what people check out @--- do not commit broken code
         there!}}
    @p{The layout can be modified easily, so there might be changes if we find
       a better layout in the future.}
    @p{The @tt{play} repository is intended as a Subversion playground, to be
       used for practice to see how things work, try new clients, see how
       different layouts work, etc.  It has the same contents @tt{iplt} had at
       the time of its creation, so there is some content to play with.  This
       repository also has "auto versioning" turned on, which means that you
       can mount it as a read-write filesystem (in operating systems that have
       this capability), and write operations translate to repository commits.}
    @;;------------------------------------------------------------
    @section{The "@tt{usr}" Repository}
    @p{The @tt{usr} repository has different structure and behavior from the
       others.  It is intended as a repository for private material, so each
       user have their own top-level directory where s/he can write to.}
    @p{This repository has auto versioning turned on so it can be mounted
       read/write, but please be aware that every edit and every file operation
       will perform a commit.}
    @subsection{Access control}
    @p{The authorization mechanism is flexible and can be easily adjusted to
       allow read/write access to other users.  For example, you can set up a
       "@tt{pub}" directory in your top-level directory that is world-readable,
       and a directory for a paper with write permissions for a few select
       users.  These permissions can be mixed in arbitrary ways, and for any
       parts of your directory.  If you want to set specific permissions up,
       you can either checkout the configuration files yourself, edit your
       section and commit, or you can
       @a[href: "mailto:eli@barzilay.org"]{email me} a request.  For security,
       changes are not applied automatically: I will get a notification email,
       check that the changes are fine, and update the working copy on the
       server (so you can email me if it looks like I missed it).  See
       @a[href: "#conf"]{below} for details on this.}
    @subsection{Some safety}
    @p{The actual files on the Subversion server which implement this
       repository are also different than the others: they are readable only to
       the user that the Apache process is runing as (@tt{apache}), so even
       users that happen to have accounts on this machine cannot see it.
       Unless the machine is broken, only the system administrators of the
       relevant machines (Eli and the systems group) can see the contents of
       these files, so they can be considered relatively secure.  One thing to
       note is that we are using "Digest" authentication, which means that
       passwords are exchanged in a safe way, but the content is not @--- so
       do not put very sensitive material in your directory.}
    @p{Two more issues are backups and hooks.  The @tt{usr} repository is safe
       in regard to these: first, the backup copy (residing on the department
       filesystem) is not world-readable.  Secondly, there are repository hooks
       that will notify you of any changes to your directory.  Further details
       in @a[href: "#hooks"]{below}.}
    @subsection{Your private structure}
    @p{In general, you check your directory out by running this:
       @cmd{svn co @(svnurl "usr/$USER") usr/$USER}
       which will create a "@tt{usr/}@i{userid}" directory with your part of
       the repository.  In this directory, you can have your own hierarchy,
       with a trunk, tags, branches, or even multiple hierarchies.  Depending
       on the layout you chose to use, you may want to check only relevant
       parts at a time.  Additional Subversion usage samples are given below.}
    @;;------------------------------------------------------------
    @section{Repository Backup}
    @p{The repositories (all except @tt{play}) are backed up by copying them to
       the department's main file server, where normal backups happen.  This
       happens every hour.  (For people who have NEU accounts, these files are
       in "@tt{/proj/scheme/svn}".)  You can copy them if you really want to.}
    @p{The @tt{usr} repository is different in that the backup copy is not
       readable to anyone but me (@tt{eli}).}
    @;;------------------------------------------------------------
    @section{Subversion Usage for the PLT Repository}
    @p{These are a few quick descriptions and command-line usage samples.
       It is intended for quick cut-paste-@em{modify} usage, and for
       instructions on some common operations.  For real documentation, see the
       Subversion web site and book @--- see the links at the
       @a[href: "#links"]{bottom} of this page.}
    @subsection{Checking out the trunk}
    @p{The first thing you will want to do is check out the @tt{plt} tree:
       @cmd{svn co @(svnurl "plt/trunk") plt}
       will check out the main trunk and put it in a local "@tt{plt}"
       directory.  The @tt{svn} command line tool is similar to @tt{cvs}: it
       uses subcommands, and includes a "@tt{help}" command that summarizes
       other commands.  For example, you can run
       @cmd{svn help co}
       to learn about using the checkout subcommand.  Note that in these help
       texts "@tt{URL}" describes some repository URL (as in the first
       example), and "@tt{WCPATH}" is a working copy path, like the one that
       the first example created.}
    @subsection{Creating a tag}
    @p{Some commands can work directly on URLs, which means that they perform
       their operation immediately.  For example, the way to create a tag is by
       copying the main trunk to a new directory in the "@tt{tags}" directory
       @--- here is how this is done:
       @cmd{svn copy @(svnurl "play/trunk") \
                     @(svnurl "play/tags/my-tag")}
       (These examples use the @tt{play} repository, you can try them out.
       Writing to the "@tt{tags}" directory of the @tt{plt} repository is
       restricted.)  When you do this, Subversion will require a log message
       immediately: there is no separate commit step since it is working
       directly on the repository.  You might see an error message telling you
       that @tt{svn} could not use an external editor @--- you can either set
       an environment variable (@tt{EDITOR} or @tt{VISUAL}) or edit your
       Subversion client configuration file (@tt{~/.subversion/config}) by
       uncommenting the "@tt{helpers}" section and specifying some
       @tt{editor-cmd}.  You can also specify a commit message using an @tt{-m}
       flag.}
    @p{Note that the "@tt{svn copy}" command works like "@tt{cp -a}": if the
       target directory that is specified exists, it will copy the source
       @em{into} that directory instead of over it.  For example, running the
       copy command when "@tt{tags/my-tag}" already exists will create your
       copy as "@tt{tags/my-tag/trunk}" instead.  You can try that and inspect
       the result by looking at @a[href: (svnurl "play/tags")]{the repository}.
       To undo this, you will need to remove the bogus directory:
       @cmd{svn del @(svnurl "play/tags/my-tag/trunk")}
       Again, you will need to provide a log message since this operation is
       performed directly on the repository.}
    @p{When you're doing such operations directly on the repository, you should
       be a bit more careful than usual @--- for example, in the above bogus
       copy case, you should not use the "@tt{-m}" which will make @tt{svn}
       fire up an editor: the file that you'll edit has a place for your log
       text at the top, and then it will indicate the change with something
       like
       @cmd{--This line, and those below, will be ignored--
            A    @(svnurl "play/tags/my-tag/trunk")}
       which shows that the wrong directory is being added.  You can try it out
       again: look at the text, and then quick without changing the commit log
       file @--- once you exit the editor, @tt{svn} will notice that you didn't
       write anything and will offer aborting the operation.}
    @subsection{Creating a branch}
    @p{Copying things in a Subversion repository is a cheap operation, which
       makes it the basic tool for tagging and branching.  The "@tt{tags}"
       directory is just the conventional place to put directories that are
       tags (they should not be edited further), and "@tt{branches}" is the
       conventional place that is used for directory copies intended for work
       without affecting the trunk.  Subversion is not doing anything special
       with any of these names, this is why using the main repository URL for a
       check-out without the "@tt{/trunk}" part will retrieve the complete
       repository, include many (mostly-identical) copies of the whole trunk.}
    @p{Say that you have the main trunk checked out:
       @cmd{svn co @(svnurl "play/trunk") play
            cd play}
       and you want to do some development that requires working on your own
       branch.  First, you should create your branch @--- this is done like the
       above, by copying the whole trunk to your own directory:
       @cmd{svn copy . @(svnurl "play/branches/my-branch")}
       The main difference here is that this command uses the working copy
       instead of a URL as the source @--- this is still doing something to a
       directory that you don't have on your disk, so it is an immediate
       server-side operation.  It is essentially the same as
       @cmd{svn copy @(svnurl "play/trunk") \
                     @(svnurl "play/branches/my-branch")}}
    @p{Now you want to start working on your copy, but the problem is that your
       working directory is still the trunk @--- you can verify that by running
       @cmd{svn info .}
       What you will want to do now is remove this directory, then re-checkout
       your new branch.  This will be expensive for an operation that needs to
       do nearly nothing since the end result is a directory with the same
       files checked out from a different place @--- so this is where the
       "@tt{switch}" command comes in.  This command is similar to doing just
       that: rechecking your current working copy from a different repository
       place, but done efficiently (merging any required changes (if any) to
       the working directory).  Furthermore, if you had any modifications, they
       will be preserved as the same modifications after the change since new
       content is merged in rather than copied.  You can try that @--- first
       edit some files and check that they are marked as changed:
       @cmd{@i{...edit files...}
            svn st .}
       (Note that "@tt{svn status}" is the way to check for things in a similar
       way that "@tt{cvs update}" is often (mis)used, "@tt{svn update}" is used
       to update your working copy only, nothing more.)}
    @p{Now that you realize that you actually want to work on your branch and
       not on the trunk, you need to switch (you can actually create the branch
       now and then switch, the result is the same since the copying is done
       directly at the server):
       @cmd{svn switch @(svnurl "play/branches/my-branch")}
       You can verify that the URL change, and that your modification are still
       there:
       @cmd{svn info .
            svn st .}
       Nothing has changed on the server yet because you didn't perform any
       commits.  Now that you work in your own private tag, you can change and
       commit anything you want @--- your work will not disturb anyone else,
       (unless the branch is intended for shared work with someone else).  You
       commit your work with
       @cmd{svn ci .}
       or with a log message on the command line:
       @cmd{svn ci -m "@i{...log message...}"}
       Note that if you use "@tt{-m.}" or any other log message that names a
       file or a directory, @tt{svn} will complain that the log message is a
       path name, so you must use "@tt{--force-log}" if you really want that
       message.}
    @subsection{Warning about @tt{svn switch}}
    @p{When you switch your working copy to a different URL, @tt{svn} will show
       you what files were changed for the switch @--- usually, this list
       will contain changes that happened on the tree you're switching to, and
       undoing changes that happened on the tree you're switching from.  Since
       the two trees are expected to be mostly similar, there should not be too
       many changes involved in this operation, and the parts that do change
       should be familiar wil recent developments.  If you switch to the wrong
       URL, however, there will be lots of changes that are required to
       transform a source tree to the unrelated target tree.  It is therefore
       advisable to be careful to specify the correct URL.}
    @p{In addition to that, it is a good idea to commit your changes before the
       switch and even better to run "@tt{svn status}" after the switch.  If
       you had no changes pending, it should not say anything.}
    @p{Again: if you @em{intend} to carry over changes (for example, the above
       situation where you've started working on the wrong tree and want to
       take your changes elsewhere), then be careful and @em{make sure you use
       the correct URL}.}
    @subsection{Copying, deleting, and renaming files}
    @p{In Subversion, changes include not only editing, adding or deleting
       files, it also tracks copying and renaming.  For example, we can change
       a file name in our branch with
       @cmd{svn mv @i{some-file}@|nbsp|@i{some-other-name}}
       A move command is just like a copy followed by a remove, but Subversion
       will carry along the file's history so you will see this change when you
       later examine the file's log.  For example,
       @cmd{> @b{svn move web/readme.txt web/readme.1st}
            A         web/readme.1st
            D         web/readme.txt
            > @b{svn ci -m "sample commit" .}
            Adding         web/readme.1st
            Deleting       web/readme.txt
            Committed revision 13.}
       and now "@tt{svn log web/readme.1st}" will show you the proper log
       history, and "@tt{svn log -v web/readme.1st}" will show you how the file
       has changed names @--- in this case you will see both the result of your
       rename operation and the result of the original rename that created your
       trunk.}
    @p{By the way, note that the @tt{svn} interface keeps original copies of
       all files, so much less operations require network compared to CVS.  For
       example, after changing files, you can use "@tt{svn revert}" to undo
       your changes.  (The cost is having very big working directories.)   See
       the manual (links @a[href: "#links"]{below}) for more commands and
       details.}
    @subsection{Merging a branch back on the trunk}
    @p{Now assume that you went through a few additional editings and commits.
       At the same time, the main trunk is being edited as well.  You will
       notice this by the revision number that will increase @--- this number
       is for the whole repository, so each commit on any part of it will
       increment the revision.  If you are the only one who commits on your
       branch, then except for the increasing revision numbers, you will not
       be aware of other work.}
    @p{At some point, you will finish your work, and then you will need to
       commit your changes to the main tree.  First, make sure that all changes
       are comitted using "@tt{svn st}".  Now, your work will be folded into a
       single commit which will be performed on the trunk @--- begin by
       switching your working copy back to the main trunk:
       @cmd{svn switch @(svnurl "play/trunk")}
       Your working copy will be modified so it will now mirror the updated
       state of the trunk, and the output of the @tt{switch} command will show
       you the changes that were done to achieve this.  Thinking in terms of
       deltas, this change is basically the reverse of your set of changes,
       composed with the changes on the trunk.}
    @p{What you need to do now is get all changes that were done on your branch
       and replay them on the main trunk (which is now the current working
       directory).  To do this, you use the "@tt{svn merge}" command @--- this
       command is similar to "@tt{svn diff}": it takes two places in the
       repository (usually the same path at different revisions) but instead of
       showing you the difference between them, it will apply them on the
       current working copy.  In fact, @tt{svn merge} is similar to piping the
       result of @tt{svn diff} onto @tt{patch} to change the current copy, and
       it could be implemented that way, with the exception of file additions,
       deletions etc, which are not expressible in a plain @tt{svn diff}
       output.}
    @p{In the case of merging changes from a branch, the path is known, but the
       problem is that you need to find the revision number range.  The last
       revision is easy @--- it is the current one that @tt{svn switch}
       reported, and that @tt{svn info} or @tt{svn up} will show if you've
       forgotten that.  The first revision is the revision that your branch was
       created at, which marks the beginning of your work.  To find this,
       "@tt{svn log}" has a useful flag, "@tt{--stop-on-copy}", which instructs
       it to stop the log at the point that the path was last copied.}
    @p{Since the root of your branch was copied exactly once when you began
       your work, then you only need to find when it was copied,
       @cmd{svn log --stop-on-copy @(svnurl "play/branches/my-branch")}
       will show you all log messages with the last one being the one that
       created your branch.  Now you have the three pieces of information that
       define your delta (@tt{path}, @tt{rev@sub{@small{1}}},
       @tt{rev@sub{@small{2}}}), and you can finally use @tt{svn merge} to
       apply it on your checked-out trunk:
       @cmd{svn merge -r rev@sub{@small{1}}:rev@sub{@small{2}} \
                @(svnurl "play/branches/my-branch")}
       This will apply the changes in that range to the current working copy,
       and show you a summary of the changes (note that the order of the
       revision numbers matters, the same path with
       @tt{rev@sub{@small{2}}:rev@sub{@small{1}}} is the delta that @em{undoes}
       your branch's work).  You can use this command multiple times with
       subranges, to apply the change in easier-to-handle parts, like applying
       revisions one-by-one.  Two useful things at this point are:
       @tt{svn merge} has a "@tt{--dry-run}" flag that will only show you the
       change summary output (indicating changes and conflicts) but not
       actually do anything; also, if you've done a merge but want to go
       back then, since these are the same as other edits, you can use
       "@tt{svn revert -R .}" to restore your tree to its previous state (note:
       you will need to manually remove added files, use "@tt{svn st}" to see
       if there are such files).}
    @p{If the merge was successful, you have now a working copy of the trunk,
       with the work from your branch applied as modifications.  You only need
       to commit these change now @--- @em{it is a very good idea to specify
       these three pieces of information (path, two revisions) in the log
       message}, since they can be used to resurrect the branch and get the
       history of work done on it.  For example, for the above merge operation,
       you should do something like
       @cmd{svn commit -m "merged rev@sub{@small{1}}:rev@sub{@small{2}} @;
                           from branches/my-branch" .}}
    @p{@b{Important note:} if you have renamed files in your branch, and that
       file was modified on the trunk, then changes will not be merged.  It
       will simply remove the trunk file and add your new file instead.  Watch
       out for such cases.}
    @p{Finally, since the branch is no longer needed, you should remove it.
       @cmd{svn del @(svnurl "play/branches/my-branch")}
       If you or anyone else will need to look at the contents of your branch
       while you were working on it, the log message will have the path and
       revision information that are sufficient to locate the branch while it
       was active.}
    @subsection{Resolving conflicts}
    @p{In rare cases where someone else worked on the same code on the trunk
       that you modified in the branch, you might have conflicts, which will be
       indicated by a "@tt{C}" in the output of @tt{svn merge}.  In this case,
       commits will fail until you resolve these conflicts manually.  This is
       the same behavior that you will get from any @tt{svn up} that results in
       a conflict with local edits.  You will end up with the original file
       which will contain conflict markers similar to the ones that CVS
       generates, and with additional files that have the previous content and
       the content from the branch at the two points.}
    @p{You can manually edit the file and resolve the conflict, copy one of the
       other files over it, or use them with some fancy utility like
       "@tt{diff3}" or Emacs's "@tt{M-x ediff}" to inspect and merge changes.
       Whatever you do, you need to take care of the content of the file and
       run "@tt{svn resolved @i{file}}" to tell Subversion that the conflict is
       resolved (and have it remove the extra files).}
    @p{Again, when you're done, simply commit your changes, with an appropriate
       log message that indicates the path and the two revisions that were used
       in the merge, and then remove your branch.}
    @subsection{Bidirectional merges}
    @p{The above procedure merged changes from one path (your branch) onto
       another (the trunk) @--- and it can be used to merge changes between any
       two paths.  For example, you can merge things from one branch to
       another, including private hierarchies that you have in your private
       branch area.}
    @p{An important case is when you have a long-lasting branch.  In this case,
       you will probably want to merge in changes from the trunk onto your
       branch.  This is a problematic point (and a classic headache), since the
       merge-changes are not treated in any special way, and when the day comes
       to merge your changes back on the trunk, your branch's delta will
       include modifications that were already performed on the trunk.  In the
       best case, Subversion will notice that these changes were already
       applied and avoid redoing them, and in the worst case you will end up
       with a mess of conflicts.}
    @p{One way to avoid this is to use the fact that copying whole trees is a
       cheap operation in Subversion.  The idea is to simply restart your work
       on a new branch which will be a copy of the updated trunk:
       @ol{@li{Create a new branch from the current trunk,
              "@tt{branches/my-branch-new}" in the usual way.}
           @li{Merge the changes from "@tt{branches/my-branch}" as above, but
               instead of merging them to the trunk, you merge them to the
               newly created branch.}
           @li{You follow the same steps, including resolving conflicts,
               comitting with a good message that has the right information,
               @em{and removing the "@tt{branches/my-branch}"} branch.}}}
    @p{This way ensures that you are never in danger of replaying some changes
       twice @--- your branch will always contain changes you did from a trunk
       snapshot.}
    @p{Now that this is done, you might consider another step:
       @ol{@li{Finally, rename "@tt{branches/my-branch-new}" to
               "@tt{branches/my-branch}", @tt{switch} to it and continue your
               work.}}
       There is a problem with this, however: Subversion considers a rename
       operation as a copy-and-delete operation, so if you will want to repeat
       this procedure again, @tt{--stop-on-copy} would stop just a little too
       early, and in addition you will need to merge changes from two different
       paths at two different revisions.  Therefore, it is better to leave the
       new branch as is, and continue working on it @--- either work on a
       sequence of "@tt{branches/my-branch-}@i{n}" branches, or alternate
       between two.  In case you share work with others on the branch, make
       sure they know about the change @--- they will need to @tt{svn switch}
       to the new branch too.}
    @subsection{Bidirectional merges: an alternative approach}
    @p{An alternative approach to dealing with bidirectional merges involves
       more bookkeeping.  The basic idea is to use Subversion revision as
       "changesets" @--- a collection of changes.  When you want to merge
       changes from the trunk onto your branch, you commit the merge with a
       message that indicates the revision range that was merged.  When you do
       that again, you first use @tt{svn log} to see the last merged range, and
       merge in changes from after that point to the current revision, and
       again, commit with a clear message.  Finally, when you want to merge
       your branch to the trunk, you inspect the log and merge in changes that
       were done on the branch @em{excluding} the revisions that are merges
       from the trunk.}
    @p{There is a tool that is bundled with the Subversion command-line client
       called @tt{svnmerge} that does this kind of bookkeeping using properties
       (see below) to keep track of merges.  If you have further information
       regarding this tool, feel free to extend this text.}
    @subsection{Properties}
    @p{Subversion has the ability to attach arbitrary properties to files and
       directories.  These properties hold arbitrary content (unlimited in
       size, and a property can even be made of binary files) and are versioned
       as well.  The @tt{svn} commands for handling properties are
       @tt{propget}, @tt{propset}, @tt{propedit}, and @tt{proplist}.  There are
       several built-in Subversion properties, all prefixed with "@tt{svn:}",
       the interesting ones are:
       @ul{@li{@tt{svn:executable} @--- if set (to any value, the convention is
               "@tt{*}") on a file, the file will be made executable when
               checked it out (on Unix-like filesystems).}
           @li{@tt{svn:mime-type} @--- determines the type of content.  This
               has two uses: it indicates whether textual diffs should be used
               (any "@tt{text/*}" type) when merging, diffing, etc.  It is also
               used when the repository is accessed via a browser: the web
               server will use this as the kind of object it returns.}
           @li{@tt{svn:eol-style} @--- determines the style of end-of-lines in
               a file: one of "@tt{native}", "@tt{CRLF}", "@tt{LF}", "@tt{CR}".
               The first will make clients use their OS's convention, and the
               others are for some fixed style.  If this is missing (or if
               @tt{svn:mime-type} is not a text type), then the file is used as
               is, as if it is binary.  We use "@tt{CRLF}" for text files that
               are used only on Windows and must always have CRLF line
               terminators (eg, batch files and DevStudio files), and
               "@tt{native}" for all other textual files.}
           @li{@tt{svn:ignore} @--- this is a property that can be put on
               directories, and its content serves the same purpose of
               "@tt{.cvsignore}" files on CVS, with the same syntax.  Setting
               it avoids "@tt{?}" entries in the output of @tt{svn status}.
               (But note that but files that match ignored patterns can still
               be added, and changes to these files will still be reported.)
               It is convenient to add and edit this property with "@tt{svn
               propedit svn:ignore}".  We use it on collection directories, to
               ignore the generated "@tt{compiled}" subdirectory.}}
       (See the Subversion book for more details.)}
    @p{In the PLT repository, the general rule is that you either set the
       @tt{svn:eol-style} property (almost always to @tt{native}), or you set
       @tt{svn:mime-type} to the appropriate type.  A repository hook (see
       below) will mail you if you have comitted files without either
       property; in the future, it may be modified to @em{reject} such
       commits.  @tt{svn:eol-style} should also be set if @tt{svn:mime-type} is
       set to some textual type like @tt{text/html} or @tt{text/css}.}
    @p{To make properties easier to manage, it is possible to specify some
       properties that are set automatically for files, based on their name
       @--- search the Subversion configuration
       file (@tt{~/.subversion/config}) for "auto-props" (there is both a
       section with specification of automatic props, and a line that enables
       them).  Note that this might be a problem with files that DrScheme saves
       in binary format but use a regular "@tt{.ss}" or "@tt{.scm}" suffix (we
       do not use such files anyway, except for rare cases like tests).}
    @subsection{@a[name: "responsibility"]{PLT Properties}}
    @p{We currently use one custom property: "@tt{plt:responsible}".  Set this
       property to your plt username to mark parts of the PLT repository that
       you are responsible for.  It could be set on a directory, marking
       everything beneath it, or on individual files.  In addition, setting it
       can override a higher level directory property that indicates different
       responsibility (in case you're in charge of a small portion of someone
       else's directory).}
    @p{This property is used to generate the responsibility tree (see the
       @(link-to "responsible.html") page), but in the future it may be used
       for additional purposes like commit notifications and automatic
       bug-report assignments.}
    @subsection{@a[name: "hooks"]{Repository hooks}}
    @p{There are various hooks that are being executed on the Subversion server
       as a result of repository operations.  The current set of hooks does the
       following:
       @ul{@li{Notification emails are sent to whoever wants them (either email
               me or see @a[href: "#conf"]{below} for a way to add yourself).}
           @li{A permission script will refuse changing stuff anywhere other
               than @tt{/branches} and @tt{/trunk}, except for a small set of
               people who are allowed to create tags in @tt{/tags}.}
           @li{Sanity checks for case-sensitivity, and for lock owners.}
           @li{Check that new files have either the @tt{svn:mime-type} or the
               @tt{svn:eol-style} property and notify if that is the case.}}
       These hooks change from time to time, as needed.}
    @p{The configuration files (see @a[href: "#conf"]{below}) that some hooks
       use have different settings for the the @tt{usr} repository.  For
       example, commit notification emails will be sent to you and only to you:
       even in directories which you decide to share with others, you will be
       only one that is notified of changes.}
    @subsection{Reminder: branches are cheap}
    @p{Again, remember that copying the trunk to a branch for your private work
       is a cheap operation.  As a general guideline, it seems like a good idea
       to follow the "Branch-When-Needed" system, which is described at the
       bottom of the
       @a[href: (concat "http://svn.collab.net/repos/svn/trunk/"
                        "doc/user/svn-best-practices.html")]{
         Subversion Best Practices}
       document and copied here:
       @ul{@li{Users commit their day-to-day work on @tt{/trunk}.}
           @li{Rule #1: @tt{/trunk} must compile and pass regression tests at
               all times.  Committers who violate this rule are publically
               humiliated.}
           @li{Rule #2: a single commit (changeset) must not be so large so as
               to discourage peer-review.}
           @li{Rule #3: if rules #1 and #2 come into conflict (i.e. it's
               impossible to make a series of small commits without disrupting
               the trunk), then the user should create a branch and commit a
               series of smaller changesets there.  This allows peer-review
               without disrupting the stability of @tt{/trunk}.}}}
    @;;------------------------------------------------------------
    @section{@a[name: "conf"]{Repository Configuration}}
    @p{The configuration files that are used by the Subversion server are
       themselves part of the repository.  They can be found in
       @div[align: 'center]{
         @a[href: (svnurl "iplt/trunk/svn/etc")]{
           @(svnurl "iplt/trunk/svn/etc")}}}
    @p{You can edit and commit changes that are relevant to you.  The changes
       will not be applied automatically @--- I will receive a notification
       email, check the changes, and update the actual directories.}
    @p{The two files that are relevant here are
       @ul{@li{"@tt{authz.conf}" controls access to parts of the @tt{usr}
               repository.  You can edit the section that corresponds to your
               directory.}
           @li{"@tt{mailer.conf}" configures email notifications.  You can add
               yourself if you want to be notified of repository changes.}}}
    @p{(If you're interested, the rest of the Subversion configuration is
       available one level above that.)}
    @;;------------------------------------------------------------
    @section{@a[name: "links"]{Subversion Links}}
    @p{The main @a[href: "http://subversion.tigris.org/"]{Subversion Site} has
       lots of useful content, it is a good idea to stop there and see what
       they offer.}
    (let* ([book "http://svnbook.red-bean.com/"]
           [bookref (lambda (label page)
                      (a href: (concat book "en/1.1/"page".html") label))])
      @p{In particular, there is the
         @a[href: book]{Version Control with Subversion}
         that you should consult.  The relevant parts are:
         @ul{@li{@(bookref "Chapter 3" "ch03")
                 is a good starting point,}
             @li{@(bookref "Appendix A" "apa")
                 is a quick guide for CVS (ex-)users,}
             @li{@(bookref "Chapter 9" "ch09")
                 is the complete reference to the @tt{svn} command line tool,}
             @li{@(bookref "Chapter 4" "ch04")
                 introduces branches and merging,}
             @li{@(bookref "Chapter 7" "ch07")
                 covers some advanced topics, in particular, configuration of
                 the @tt{svn} client, and properties.}}}
      @p{Also, there is a bunch of good dcuments in the HowTo section of
         @a[href: "http://subversion.tigris.org/servlets/ProjectDocumentList"]{
           Subversion Documents & files}:
         @ul{@li{@a[href: (concat "http://svn.collab.net/repos/svn/trunk/"
                                  "doc/user/svn-best-practices.html")]{
                   Subversion Best Practices}}
             @li{@a[href: (concat "http://svn.collab.net/repos/svn/trunk/"
                                  "doc/user/cvs-crossover-guide.html")]{
                   CVS to SVN Crossover Guide}}
             @li{@a[href: (concat "http://subversion.tigris.org/"
                                  "files/documents/15/177/svn-ref.ps")]{
                   Subversion Quick Reference (PS)}}}})))
