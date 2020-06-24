#!/bin/sh
#| -*- scheme -*-
flags=""
# flags="-ll errortrace scheme/base" # for debugging
if [ -x "$PLTHOME/bin/mzscheme" ]; then
  exec "$PLTHOME/bin/mzscheme" $flags -r "$0" "$@"
else
  exec "mzscheme" $flags -r "$0" "$@"
fi
|#

(require (prefix-in old: "old/common/build.ss")
         (prefix-in new: "new/build.ss"))
(fprintf (current-error-port) ">>> Building old content\n")
(old:build)
(fprintf (current-error-port) ">>> Building new content\n")
(parameterize ([current-directory "www"]) (new:build))
(fprintf (current-error-port) ">>> Distributing\n")
(old:distribute-all)
