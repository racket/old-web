#lang scheme/base

(provide (all-defined-out))

;; see the readme file for values in this table
(define default-mappings
  '(("www"           "http://www.plt-scheme.org")
    ("download"      "http://download.plt-scheme.org")
    ("bugs"          "http://bugs.plt-scheme.org")
    ("svn"           "http://svn.plt-scheme.org")
    ("packages"      "/www/software")
    ("cgi-bin"       "http://download.plt-scheme.org/cgi-bin")
    ("internal"      "https://internal.plt-scheme.org")
    ("mail"          "http://mail.plt-scheme.org")
    ;; these are pre-release skeletons,
    ;; the real site is made by build/patch-html
    ("pre"           "http://pre.plt-scheme.org")
    ;; the content of drscheme.org is a soft link into plt-scheme.org
    ;; -- No longer: drscheme.org is the same as plt-scheme.org
    ;; ("/www/software/drscheme" "http://www.drscheme.org")
    ))

(define distributions
  ;; Each is a "hostname:dest-path" , and then a list of directories to put
  ;; in that path.  A directory can be "dir:dest" which will install "dir" as
  ;; "dest" in the destination path.  ("dest" should not be a top-level
  ;; directory that already exists.)
  '(("www.plt-scheme.org:/plt-content" "www")
    ("download.plt-scheme.org:/www/old" "download" "bugs" "internal" "mail"
     "cgi-bin" "www") ; copy www there too, just in case
    ("svn.plt-scheme.org:/home/svn" "svn:html")
    (#f "pre" "packages"))) ; skip

(define ignored-files #rx#"(^\\.|^CVS$|~$)")

;; the ftp base and pre-release directories on the download server
(define ftp-dir "/var/ftp/pub/plt/")

(define page-icon "/www/plticon.ico")

(define icon-location "/www")

;; these are relative to source-dir
(define source-image-dir   "../../misc/images")
(define announcements-file "../../misc/announcements.txt")
(define screenshots-dir    "../../misc/screenshots")

(define symlinks
  '((plt        "/www/")
    (drscheme   "/packages/drscheme/")
    (mzscheme   "/packages/mzscheme/")
    (mred       "/packages/mred/")
    (mzc        "/packages/mzc/")
    (software   "/packages/")
    (license    "/www/license/")
    (map        "/www/map.html")
    (bug-report "/bugs/")
    (bug-query  "/bugs/query/")
    (docs       "/download/doc/")
    (screenshots "/www/screenshots/")
    (techreports "/www/techreports/")
    (planet "PLaneT" "http://planet.plt-scheme.org")
    (pre-release-installers "/pre/installers/")
    (pre-release-top        "/pre/")
    (pre-release-docs       "/pre/docs/")
    ;; (pre-release-search     "/pre/search.html")
    (r5rs-scheme
     "Scheme" "http://www.schemers.org/Documents/Standards/R5RS/")
    (r5rs-formal (span "R" (sup "5") "RS")
     "http://www.schemers.org/Documents/Standards/R5RS/")
    (htdp (i "How to Design Programs") "http://www.htdp.org/")
    (htus (i "How to Use Scheme") "http://www.htus.org/")
    (teachscheme! "TeachScheme!" "http://www.teach-scheme.org/")
    (tour "Tour of DrScheme" "/packages/drscheme/tour/")
    (fixnum (i "Teach Yourself Scheme in Fixnum Days")
            "http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme.html")
    (schematics "Schematics" "http://sourceforge.net/projects/schematics/")
    (cookbook "The Schematics Cookbook" "http://schemecookbook.org/")
    (schemers (tt "schemers.org") "http://www.schemers.org/")))

;; hack for new style

(define-struct navbar-ele (link key))

(define navbar-links
  (map (lambda (x)
         (let-values ([(navkey title url) (apply values x)])
           (make-navbar-ele `(a ([href ,url]) ,title) navkey)))
       '([about         "About"         "http://plt-scheme.org/"]
         [download      "Download"      "http://download.plt-scheme.org/"]
         [documentation "Documentation" "http://docs.plt-scheme.org/"]
         [planet        "PLaneT"        "http://planet.plt-scheme.org/"]
         [community     "Community"     "http://plt-scheme.org/community.html"]
         [blog          (span "Outreach" nbsp "&" nbsp "Research") "http://plt-scheme.org/outreach+research.html"])))

;; Google tracking
(define body-footer
  `("\n"
    (script [(src "http://www.google-analytics.com/urchin.js")
             (type "text/javascript")]
      "\n")
    "\n"
    (script [(type "text/javascript")]
      "\n"
      "_uacct=\"UA-808258-1\";\n"
      "_udn=\"plt-scheme.org\";\n"
      "urchinTracker();\n")
    "\n"))
