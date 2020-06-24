#reader"../common/html-script.ss"

(define title "Using the nightly PLT builds")

(define (run)
  (define this (regexp-replace #rx"/$" (url "") ""))
  (write-tall-page title #:search 'source
    @p{Using the nightly builds to get the latest version is very simple, and
       does not require Subversion.  If you use the `installers' directory,
       then things are as simple as they are with a normal PLT distribution
       @mdash the only slight difference is that by default the directory name
       contains the version number so it does not clobber an official
       installation (this also works on Windows, where the registry keys are
       separate for each nightly version).}
    @p{But there is a lot of material in here that might fit better a script
       that updates a PLT tree automatically.  For this, the only tools you
       will need are GNU tar, a utility to fetch files from the web, and some
       scripting facility.  For example, assuming that your `@tt{plt}'
       directory is in "@tt{$BASE}", retrieving the latest source tree is as
       simple as:
       @blockquote{@pre{
         cd $BASE
         wget @(url "plt-src.tgz" #t) -O - | tar xzf -}}
       or with `@tt{curl}':
       @blockquote{@pre{
         cd $BASE
         curl @(url "plt-src.tgz" #t) | tar xzf -}}}
    @p{This will fetch and unpack the full `@tt{plt}' source tree at the
       current directory, on top of any `@tt{plt}' directory that might happen
       to be there.  Since it probably doesn't make sense to have older
       binaries and newer source files, it is a good idea to remove any
       previous tree (if any):
       @blockquote{@pre{
         cd $BASE
         rm -rf plt
         curl @(url "plt-src.tgz" #t) | tar xzf -}}}
    @p{This is possible with any of the subsets that are packed as tgz files.
       For example, to update just the documentation, do this:
       @blockquote{@pre{
         cd $BASE
         wget @(url "docs/plt-docs.tgz" #t) -O - | tar xzf -}}
       (Note that it is not necessary to remove the previous tree for this.)}
    @p{To update the binaries for Linux (over an existing `plt' tree):
       @blockquote{@pre{
         cd $BASE
         rm -rf plt
         wget @(url "binaries/i386-linux/plt-i386-linux-binaries.tgz" #t) @;
               -O - \
           || tar xzf -
         cd plt}}
       To get a fully built tree for Solaris:
       @blockquote{@pre{
         cd $BASE
         rm -rf plt
         wget @(url "binaries/sparc-solaris/plt-sparc-solaris-full.tgz" #t) @;
               -O - \
           || tar xzf -
         cd plt}}
       Note that there is no "install" step: the archive contains a
       ready-to-run tree.}
    @p{Finally, there is a `@tt{stamp}' file in the nightly build directory
       that can be used for scripts that periodically poll for new builds.
       This file is updated last in the build process, so if a build fails it
       will stay the same and not fool you into getting the same build.  To
       demonstrate using this, here is an `@tt{sh}' script that compares a
       local copy of the `@tt{stamp}' file to the one on the web, and if there
       is any difference, retrieves and installs the new full FreeBSD build
       (assuming it is in my home directory):
       @blockquote{@pre{
         #!/bin/sh
         cd
         URL="@this"
         touch stamp # make sure that it is there
         if ! curl -s $URL/stamp | diff -q stamp - >/dev/null 2>&1; then
           curl -s $URL/stamp > stamp # remember the new stamp
           #----------
           rm -rf plt
           wget $URL/binaries/i386-freebsd/plt-i386-freebsd-full.tgz -O - @;
            | tar xzf -
           #----------
         fi}}
       The marked part of this script can be replaced by any of the options
       mentioned above, for other platforms or something other than retrieving
       a full build.}
    @p{This script will retreive and install a new build only when one is
       ready.  It is suitable for running periodically via a crontab entry.
       For example, save it in `@tt{~/bin/update-full-plt}', run
       `@tt{crontab -e}' to edit your @tt{crontab} entries, and add a line that
       looks like this:
       @blockquote{@pre{  13 */6 * * * ~/bin/update-full-plt}}
       This will run the script on the 13th minute of every sixth hour.  It is
       harmless to run it every hour, but there's no real need for it.
       Currently, the nightly build process starts at 3:50am (EDT) and lasts
       for about two hours, but every once in a while there would be additional
       builds (eg, after a minor version change).}
    @section{A note about defensive scripting:}
    @p{Writing scripts that work for you is easy.  Making them robust enough to
       be usable by others or by site-wide setups can be a delicate job @mdash
       you have to plan for bad @tt{PATH} setting (for example, a cron job is
       started in a pretty much bare environment), errors that happen in one
       command etc.  The following is just like the above script, modified to
       be more robust in the following way:
       @ol{@li{The @tt{PATH} environment variable is explicitly set.}
           @li{Use variable definitions to make customization easy.}
           @li{Usages of `@tt{$URL}' and others are quoted in case they will
               ever contain spaces.}
           @li{If we fail to retreive a file, we quit the script.}
           @li{Use a temporary directory to retreive the tree, and then move it
               to its real place (so if it fails we don't end up with no
               `@tt{plt}') through renaming (if we delete `@tt{plt}' and then
               rename the new one, we might fail halfway into the deletion).}
           @li{Also, there might be some binary process running from an old
               file which might prevent removing the directory, so failure to
               remove the old tree does not abort the script.}
           @li{The new stamp is remembered only if everything succeeded.}}}
    @hr{}
    @blockquote{@pre{
      #!/bin/sh
      PATH="/bin:/usr/bin"
      # where is our plt tree placed?
      MAINDIR="$HOME"
      # where should the local stamp file copy be stored?
      STAMP="$MAINDIR/stamp"
      # where is the online stuff?
      URL="@this"
      cd "$MAINDIR"
      touch "$STAMP" # make sure that it is there
      curl -s "$URL/stamp" > "$STAMP-new"
      if diff -q "$STAMP" "$STAMP-new" >/dev/null 2>&1; then
        # nothing changed
        rm "$STAMP-new"
      else
        #----------
        mkdir "$MAINDIR/plt-temp-$$"
        cd "$MAINDIR/plt-temp-$$"
        wget "$URL/binaries/i386-linux/plt-i386-linux-full.tgz" -O - \
        | tar xzf - \
        || exit 1
        cd "$MAINDIR"
        if [ -e "plt" ]; then mv "plt" "plt-temp-$$/plt-old"; fi \
        && mv "plt-temp-$$/plt" . \
        || exit 1
        rm -rf "plt-temp-$$"
        #----------
        cd "$MAINDIR"
        rm "$STAMP" # remember the new stamp only if no failure so far
        mv "$STAMP-new" "$STAMP"
      fi
    }}
    @hr{}))
