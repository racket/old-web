#reader"../common/html-script.ss"

(define warning:old-installers
   @div[align: 'center style: "background-color: #fcc;"]{
     These downloads are for
     @b{outdated versions}, which are no longer maintained.
     @br{}
     For current and newer versions, please go to the
     @a[href: "http://racket-lang.org/"]{web site for Racket}.})

(define packages
  '(plt mz libs mysterx mzcom srpersist openssl drschemejr mrspidey))

(define ignored-packages
  ;; packages that have no download (and software) page
  '(sgl))

(define disttypes
  '(bin src))

(define platforms
  '(;; binary platforms
    i386-win32
    i386-osx-mac ppc-osx-mac i386-darwin ppc-darwin
    ppc-mac-classic 68k-mac-classic
    i386-linux i386-linux-gcc2 i386-linux-fc2 i386-linux-fc5 i386-linux-fc6
    i386-linux-f7 x86_64-linux-f7 i386-linux-f9 i386-linux-f12
    i386-linux-debian i386-linux-debian-testing i386-linux-debian-unstable
    i386-linux-ubuntu i386-linux-ubuntu510 i386-linux-ubuntu-dapper
    i386-linux-ubuntu-edgy i386-linux-ubuntu-feisty i386-linux-ubuntu-hardy
    i386-linux-ubuntu-intrepid i386-linux-ubuntu-jaunty
    i386-freebsd
    i386-kernel
    i386-linux-rh
    sparc-solaris
    ;; source platforms
    win mac unix linux-rh all))

(define extensions
  '(tgz sh zip src.rpm i386.rpm sit sit.bin dmg exe plt))

(define bundles-base-url/ "/download/bundles/")

(define mirrors
  ;; The following is a sequence of
  ;;   (location url reposnisble-name email [techincal-contact])
  `(("Main download (USA, Massachusetts, Northeastern University)"
     ,bundles-base-url/
     "Eli Barzilay"
     "eli@barzilay.org")
    ("USA, Illinois (Northwestern University)"
     "http://www.eecs.northwestern.edu/plt-scheme/"
     "Robby Findler"
     "robby@eecs.northwestern.edu")
    ("USA, Utah (University of Utah)"
     "http://www.cs.utah.edu/plt/download/"
     "Matthew Flatt"
     "mflatt@cs.utah.edu")
    #; ; Scheme guy left
    ("France (Institut Pasteur)"
     "ftp://ftp.pasteur.fr/pub/computing/Scheme/plt-scheme/"
     "Marc Badouin"
     "babafou@pasteur.fr"
     "Pasteur Institute FTP ftpmain@pasteur.fr")
    (("Germany (Universit" auml "t" " " "T" uuml "bingen)")
     "http://mirror.informatik.uni-tuebingen.de/mirror/plt/"
     "Marcus Crestani"
     "crestani@informatik.uni-tuebingen.de")
    ("Belgium (Infogroep, Vrije Universiteit Brussel)"
     "ftp://infogroep.be/pub/plt/bundles/"
     "Daniel Kucharski"
     "Daniel.Kucharski@vub.ac.be")
    #; ; ftp down (permanently?)
    ("Mexico (Wish Computing)"
     "ftp://morpheus.wish.com.mx/pub/plt/"
     "Francisco Solsona"
     "solsona@acm.org")
    ("Austria (Vienna University of Technology)"
     "http://gd.tuwien.ac.at/languages/scheme/plt/"
     "Antonin Sprinzl"
     "Antonin.Sprinzl@tuwien.ac.at")
    ("Turkey, Istanbul (Bilgi University)"
     "http://russell.cs.bilgi.edu.tr/plt-bundles/"
     "Onur Gungor"
     "onurgu@cs.bilgi.edu.tr")))

;; ============================================================================
;; This should be the result of running this in the bundles directory:
;;   cd ~ftp/pub/plt/bundles
;;   find . -type f -exec du -bh \{\} \; | sort -k 2
;; There should be a way to do this automatically, but for this the html
;; scripts will need to have a reliable way to do this on the download
;; directory.  (The sorting is just to make it easy to browse, and to make
;; minimal diffs, it doesn't have to follow the version sequence.)
#|

2.6M	./053/plt/plt-053-bin-i386-win32.exe
824K	./103/drschemejr/drschemejr-103-bin-68k-mac-classic.sit.bin
725K	./103/drschemejr/drschemejr-103-bin-i386-linux.tgz
977K	./103/drschemejr/drschemejr-103-bin-i386-win32.exe
850K	./103/drschemejr/drschemejr-103-bin-ppc-mac-classic.sit.bin
738K	./103/drschemejr/drschemejr-103-bin-sparc-solaris.tgz
364K	./103/mrspidey/mrspidey-103-src-all.plt
330K	./103/mysterx/mysterx-103-bin-i386-win32.plt
735K	./103/mz/mz-103-bin-68k-mac-classic.tgz
2.0M	./103/mz/mz-103-bin-i386-kernel.tgz
2.1M	./103/mz/mz-103-bin-i386-linux-rh.i386.rpm
670K	./103/mz/mz-103-bin-i386-linux.tgz
796K	./103/mz/mz-103-bin-i386-win32.zip
774K	./103/mz/mz-103-bin-ppc-mac-classic.tgz
684K	./103/mz/mz-103-bin-sparc-solaris.tgz
1.6M	./103/mz/mz-103-src-linux-rh.src.rpm
2.3M	./103/mz/mz-103-src-mac.tgz
1.6M	./103/mz/mz-103-src-unix.tgz
1.8M	./103/mz/mz-103-src-win.zip
349K	./103/mzcom/mzcom-103-bin-i386-win32.plt
3.2M	./103/plt/plt-103-bin-68k-mac-classic.sit.bin
5.6M	./103/plt/plt-103-bin-i386-linux-rh.i386.rpm
2.9M	./103/plt/plt-103-bin-i386-linux.tgz
3.4M	./103/plt/plt-103-bin-i386-win32.exe
3.3M	./103/plt/plt-103-bin-ppc-mac-classic.sit.bin
2.9M	./103/plt/plt-103-bin-sparc-solaris.tgz
4.6M	./103/plt/plt-103-src-linux-rh.src.rpm
4.8M	./103/plt/plt-103-src-mac.tgz
4.6M	./103/plt/plt-103-src-unix.tgz
5.1M	./103/plt/plt-103-src-win.zip
228K	./103/srpersist/srpersist-103-bin-i386-win32.plt
139K	./103/srpersist/srpersist-103-src-all.plt
329K	./103p1/mysterx/mysterx-103p1-bin-i386-win32.plt
735K	./103p1/mz/mz-103p1-bin-68k-mac-classic.tgz
2.0M	./103p1/mz/mz-103p1-bin-i386-kernel.tgz
2.1M	./103p1/mz/mz-103p1-bin-i386-linux-rh.i386.rpm
670K	./103p1/mz/mz-103p1-bin-i386-linux.tgz
796K	./103p1/mz/mz-103p1-bin-i386-win32.zip
774K	./103p1/mz/mz-103p1-bin-ppc-mac-classic.tgz
684K	./103p1/mz/mz-103p1-bin-sparc-solaris.tgz
1.6M	./103p1/mz/mz-103p1-src-linux-rh.src.rpm
2.3M	./103p1/mz/mz-103p1-src-mac.tgz
1.6M	./103p1/mz/mz-103p1-src-unix.tgz
1.8M	./103p1/mz/mz-103p1-src-win.zip
3.2M	./103p1/plt/plt-103p1-bin-68k-mac-classic.sit.bin
5.6M	./103p1/plt/plt-103p1-bin-i386-linux-rh.i386.rpm
2.9M	./103p1/plt/plt-103p1-bin-i386-linux.tgz
3.4M	./103p1/plt/plt-103p1-bin-i386-win32.exe
3.3M	./103p1/plt/plt-103p1-bin-ppc-mac-classic.sit
2.9M	./103p1/plt/plt-103p1-bin-sparc-solaris.tgz
4.6M	./103p1/plt/plt-103p1-src-linux-rh.src.rpm
4.8M	./103p1/plt/plt-103p1-src-mac.tgz
4.6M	./103p1/plt/plt-103p1-src-unix.tgz
5.1M	./103p1/plt/plt-103p1-src-win.zip
391K	./200/mysterx/mysterx-200-bin-i386-win32.plt
1.1M	./200/mz/mz-200-bin-i386-linux-rh.i386.rpm
1.1M	./200/mz/mz-200-bin-i386-linux.tgz
1.4M	./200/mz/mz-200-bin-i386-win32.zip
1.3M	./200/mz/mz-200-bin-ppc-osx-mac.dmg
1.1M	./200/mz/mz-200-bin-sparc-solaris.tgz
3.4M	./200/mz/mz-200-src-linux-rh.src.rpm
3.4M	./200/mz/mz-200-src-unix.tgz
3.7M	./200/mz/mz-200-src-win.zip
67K	./200/mzcom/mzcom-200-bin-i386-win32.plt
4.0M	./200/plt/plt-200-bin-i386-linux-rh.i386.rpm
3.9M	./200/plt/plt-200-bin-i386-linux.tgz
4.3M	./200/plt/plt-200-bin-i386-win32.exe
4.1M	./200/plt/plt-200-bin-ppc-osx-mac.dmg
3.9M	./200/plt/plt-200-bin-sparc-solaris.tgz
6.7M	./200/plt/plt-200-src-linux-rh.src.rpm
6.7M	./200/plt/plt-200-src-unix.tgz
7.7M	./200/plt/plt-200-src-win.zip
243K	./200/srpersist/srpersist-200-bin-i386-win32.plt
143K	./200/srpersist/srpersist-200-src-all.plt
445K	./201/mysterx/mysterx-201-bin-i386-win32.plt
1.1M	./201/mz/mz-201-bin-i386-linux-rh.i386.rpm
1.1M	./201/mz/mz-201-bin-i386-linux.tgz
1.1M	./201/mz/mz-201-bin-i386-win32.zip
2.5M	./201/mz/mz-201-bin-ppc-osx-mac.dmg
1.1M	./201/mz/mz-201-bin-sparc-solaris.tgz
2.3M	./201/mz/mz-201-src-linux-rh.src.rpm
2.3M	./201/mz/mz-201-src-unix.tgz
2.6M	./201/mz/mz-201-src-win.zip
79K	./201/mzcom/mzcom-201-bin-i386-win32.plt
4.2M	./201/plt/plt-201-bin-i386-linux-rh.i386.rpm
4.0M	./201/plt/plt-201-bin-i386-linux.tgz
4.6M	./201/plt/plt-201-bin-i386-win32.exe
4.0M	./201/plt/plt-201-bin-ppc-mac-classic.sit
5.6M	./201/plt/plt-201-bin-ppc-osx-mac.dmg
4.1M	./201/plt/plt-201-bin-sparc-solaris.tgz
5.7M	./201/plt/plt-201-src-linux-rh.src.rpm
5.7M	./201/plt/plt-201-src-unix.tgz
8.0M	./201/plt/plt-201-src-win.zip
247K	./201/srpersist/srpersist-201-bin-i386-win32.plt
144K	./201/srpersist/srpersist-201-src-all.plt
445K	./202/mysterx/mysterx-202-bin-i386-win32.plt
1.1M	./202/mz/mz-202-bin-i386-linux-rh.i386.rpm
1.1M	./202/mz/mz-202-bin-i386-linux.tgz
1.4M	./202/mz/mz-202-bin-i386-win32.zip
1.6M	./202/mz/mz-202-bin-ppc-osx-mac.dmg
1.1M	./202/mz/mz-202-bin-sparc-solaris.tgz
2.4M	./202/mz/mz-202-src-linux-rh.src.rpm
3.0M	./202/mz/mz-202-src-mac.tgz
2.4M	./202/mz/mz-202-src-unix.tgz
2.7M	./202/mz/mz-202-src-win.zip
79K	./202/mzcom/mzcom-202-bin-i386-win32.plt
4.2M	./202/plt/plt-202-bin-i386-linux-rh.i386.rpm
4.1M	./202/plt/plt-202-bin-i386-linux.tgz
4.6M	./202/plt/plt-202-bin-i386-win32.exe
4.0M	./202/plt/plt-202-bin-ppc-mac-classic.sit
5.5M	./202/plt/plt-202-bin-ppc-osx-mac.dmg
4.1M	./202/plt/plt-202-bin-sparc-solaris.tgz
5.9M	./202/plt/plt-202-src-linux-rh.src.rpm
6.0M	./202/plt/plt-202-src-mac.tgz
5.9M	./202/plt/plt-202-src-unix.tgz
6.9M	./202/plt/plt-202-src-win.zip
247K	./202/srpersist/srpersist-202-bin-i386-win32.plt
144K	./202/srpersist/srpersist-202-src-all.plt
1.1M	./203/libs/libs-203-bin-i386-win32.exe
1.3M	./203/libs/libs-203-bin-ppc-osx-mac.dmg
448K	./203/mysterx/mysterx-203-bin-i386-win32.plt
1.5M	./203/mz/mz-203-bin-i386-win32.zip
1.9M	./203/mz/mz-203-bin-ppc-osx-mac.dmg
1.2M	./203/mz/mz-203-bin-sparc-solaris.tgz
3.1M	./203/mz/mz-203-src-mac.tgz
2.4M	./203/mz/mz-203-src-unix.tgz
2.8M	./203/mz/mz-203-src-win.zip
82K	./203/mzcom/mzcom-203-bin-i386-win32.plt
6.0M	./203/plt/plt-203-bin-i386-linux.i386.rpm
4.8M	./203/plt/plt-203-bin-i386-win32.exe
4.2M	./203/plt/plt-203-bin-ppc-mac-classic.sit
5.4M	./203/plt/plt-203-bin-ppc-osx-mac.dmg
4.3M	./203/plt/plt-203-bin-sparc-solaris.tgz
6.2M	./203/plt/plt-203-src-mac.tgz
6.0M	./203/plt/plt-203-src-unix.tgz
7.2M	./203/plt/plt-203-src-win.zip
219K	./203/srpersist/srpersist-203-bin-i386-win32.plt
116K	./203/srpersist/srpersist-203-src-all.plt
1.1M	./204/libs/libs-204-bin-i386-win32.exe
1.3M	./204/libs/libs-204-bin-ppc-osx-mac.dmg
461K	./204/mysterx/mysterx-204-bin-i386-win32.plt
1.9M	./204/mz/mz-204-bin-i386-win32.zip
1.9M	./204/mz/mz-204-bin-ppc-osx-mac.dmg
1.4M	./204/mz/mz-204-bin-sparc-solaris.tgz
3.4M	./204/mz/mz-204-src-mac.tgz
2.8M	./204/mz/mz-204-src-unix.tgz
3.1M	./204/mz/mz-204-src-win.zip
82K	./204/mzcom/mzcom-204-bin-i386-win32.plt
661K	./204/openssl/openssl-204-bin-i386-win32.plt
40K	./204/openssl/openssl-204-bin-ppc-osx-mac.plt
27K	./204/openssl/openssl-204-src-all.plt
5.3M	./204/plt/plt-204-bin-i386-win32.exe
4.5M	./204/plt/plt-204-bin-ppc-mac-classic.sit
7.9M	./204/plt/plt-204-bin-ppc-osx-mac.dmg
4.7M	./204/plt/plt-204-bin-sparc-solaris.tgz
6.7M	./204/plt/plt-204-src-mac.tgz
6.6M	./204/plt/plt-204-src-unix.tgz
7.7M	./204/plt/plt-204-src-win.zip
220K	./204/srpersist/srpersist-204-bin-i386-win32.plt
117K	./204/srpersist/srpersist-204-src-all.plt
1.2M	./205/libs/libs-205-bin-i386-win32.exe
1.3M	./205/libs/libs-205-bin-ppc-osx-mac.dmg
604K	./205/mysterx/mysterx-205-bin-i386-win32.plt
1.6M	./205/mz/mz-205-bin-i386-linux.tgz
2.0M	./205/mz/mz-205-bin-i386-win32.zip
1.9M	./205/mz/mz-205-bin-ppc-osx-mac.dmg
1.5M	./205/mz/mz-205-bin-sparc-solaris.tgz
3.8M	./205/mz/mz-205-src-mac.tgz
3.1M	./205/mz/mz-205-src-unix.tgz
3.6M	./205/mz/mz-205-src-win.zip
90K	./205/mzcom/mzcom-205-bin-i386-win32.plt
675K	./205/openssl/openssl-205-bin-i386-win32.plt
43K	./205/openssl/openssl-205-bin-ppc-osx-mac.plt
28K	./205/openssl/openssl-205-src-all.plt
5.0M	./205/plt/plt-205-bin-i386-linux.tgz
5.8M	./205/plt/plt-205-bin-i386-win32.exe
7.4M	./205/plt/plt-205-bin-ppc-osx-mac.dmg
5.1M	./205/plt/plt-205-bin-sparc-solaris.tgz
7.8M	./205/plt/plt-205-src-mac.tgz
7.6M	./205/plt/plt-205-src-unix.tgz
9.0M	./205/plt/plt-205-src-win.zip
441K	./205/sgl/sgl-205-bin-i386-win32.plt
149K	./205/sgl/sgl-205-bin-ppc-osx-mac.plt
65K	./205/sgl/sgl-205-src-all.plt
1.3M	./206/libs/libs-206-bin-i386-win32.exe
1.4M	./206/libs/libs-206-bin-ppc-osx-mac.dmg
2.8M	./206/mz/mz-206-bin-i386-linux-gcc2.sh
2.8M	./206/mz/mz-206-bin-i386-linux.sh
2.4M	./206/mz/mz-206-bin-i386-win32.exe
2.7M	./206/mz/mz-206-bin-ppc-darwin.sh
2.8M	./206/mz/mz-206-bin-ppc-osx-mac.dmg
3.2M	./206/mz/mz-206-bin-sparc-solaris.sh
3.2M	./206/mz/mz-206-src-mac.dmg
3.0M	./206/mz/mz-206-src-unix.tgz
3.4M	./206/mz/mz-206-src-win.zip
10M	./206/plt/plt-206-bin-i386-linux-gcc2.sh
11M	./206/plt/plt-206-bin-i386-linux.sh
7.3M	./206/plt/plt-206-bin-i386-win32.exe
9.9M	./206/plt/plt-206-bin-ppc-darwin.sh
10M	./206/plt/plt-206-bin-ppc-osx-mac.dmg
11M	./206/plt/plt-206-bin-sparc-solaris.sh
8.9M	./206/plt/plt-206-src-mac.dmg
8.4M	./206/plt/plt-206-src-unix.tgz
10M	./206/plt/plt-206-src-win.zip
136K	./206/srpersist/srpersist-206-bin-i386-win32.plt
35K	./206/srpersist/srpersist-206-src-all.plt
1.3M	./206p1/libs/libs-206p1-bin-i386-win32.exe
1.4M	./206p1/libs/libs-206p1-bin-ppc-osx-mac.dmg
2.8M	./206p1/mz/mz-206p1-bin-i386-linux-gcc2.sh
2.8M	./206p1/mz/mz-206p1-bin-i386-linux.sh
2.4M	./206p1/mz/mz-206p1-bin-i386-win32.exe
2.7M	./206p1/mz/mz-206p1-bin-ppc-darwin.sh
2.8M	./206p1/mz/mz-206p1-bin-ppc-osx-mac.dmg
3.2M	./206p1/mz/mz-206p1-bin-sparc-solaris.sh
2.9M	./206p1/mz/mz-206p1-src-mac.dmg
2.7M	./206p1/mz/mz-206p1-src-unix.tgz
3.1M	./206p1/mz/mz-206p1-src-win.zip
11M	./206p1/plt/plt-206p1-bin-i386-linux-gcc2.sh
11M	./206p1/plt/plt-206p1-bin-i386-linux.sh
7.3M	./206p1/plt/plt-206p1-bin-i386-win32.exe
10M	./206p1/plt/plt-206p1-bin-ppc-darwin.sh
11M	./206p1/plt/plt-206p1-bin-ppc-osx-mac.dmg
11M	./206p1/plt/plt-206p1-bin-sparc-solaris.sh
8.9M	./206p1/plt/plt-206p1-src-mac.dmg
8.4M	./206p1/plt/plt-206p1-src-unix.tgz
11M	./206p1/plt/plt-206p1-src-win.zip
136K	./206p1/srpersist/srpersist-206p1-bin-i386-win32.plt
35K	./206p1/srpersist/srpersist-206p1-src-all.plt
1.3M	./207/libs/libs-207-bin-i386-win32.exe
1.4M	./207/libs/libs-207-bin-ppc-osx-mac.dmg
2.7M	./207/mz/mz-207-bin-i386-freebsd.sh
2.8M	./207/mz/mz-207-bin-i386-linux-debian.sh
2.8M	./207/mz/mz-207-bin-i386-linux-gcc2.sh
2.8M	./207/mz/mz-207-bin-i386-linux.sh
2.5M	./207/mz/mz-207-bin-i386-win32.exe
2.7M	./207/mz/mz-207-bin-ppc-darwin.sh
2.8M	./207/mz/mz-207-bin-ppc-osx-mac.dmg
3.2M	./207/mz/mz-207-bin-sparc-solaris.sh
2.9M	./207/mz/mz-207-src-mac.dmg
2.7M	./207/mz/mz-207-src-unix.tgz
3.1M	./207/mz/mz-207-src-win.zip
12M	./207/plt/plt-207-bin-i386-freebsd.sh
12M	./207/plt/plt-207-bin-i386-linux-debian.sh
12M	./207/plt/plt-207-bin-i386-linux-gcc2.sh
12M	./207/plt/plt-207-bin-i386-linux.sh
8.4M	./207/plt/plt-207-bin-i386-win32.exe
12M	./207/plt/plt-207-bin-ppc-darwin.sh
12M	./207/plt/plt-207-bin-ppc-osx-mac.dmg
12M	./207/plt/plt-207-bin-sparc-solaris.sh
11M	./207/plt/plt-207-src-mac.dmg
11M	./207/plt/plt-207-src-unix.tgz
12M	./207/plt/plt-207-src-win.zip
136K	./207/srpersist/srpersist-207-bin-i386-win32.plt
145K	./207/srpersist/srpersist-207-src-all.plt
1.3M	./208/libs/libs-208-bin-i386-win32.exe
1.4M	./208/libs/libs-208-bin-ppc-osx-mac.dmg
2.7M	./208/mz/mz-208-bin-i386-freebsd.sh
2.8M	./208/mz/mz-208-bin-i386-linux-debian.sh
2.8M	./208/mz/mz-208-bin-i386-linux-gcc2.sh
2.8M	./208/mz/mz-208-bin-i386-linux.sh
2.5M	./208/mz/mz-208-bin-i386-win32.exe
2.7M	./208/mz/mz-208-bin-ppc-darwin.sh
2.9M	./208/mz/mz-208-bin-ppc-osx-mac.dmg
3.2M	./208/mz/mz-208-bin-sparc-solaris.sh
3.2M	./208/mz/mz-208-src-mac.dmg
2.9M	./208/mz/mz-208-src-unix.tgz
3.3M	./208/mz/mz-208-src-win.zip
11M	./208/plt/plt-208-bin-i386-freebsd.sh
12M	./208/plt/plt-208-bin-i386-linux-debian.sh
12M	./208/plt/plt-208-bin-i386-linux-gcc2.sh
12M	./208/plt/plt-208-bin-i386-linux.sh
8.0M	./208/plt/plt-208-bin-i386-win32.exe
11M	./208/plt/plt-208-bin-ppc-darwin.sh
11M	./208/plt/plt-208-bin-ppc-osx-mac.dmg
12M	./208/plt/plt-208-bin-sparc-solaris.sh
11M	./208/plt/plt-208-src-mac.dmg
11M	./208/plt/plt-208-src-unix.tgz
12M	./208/plt/plt-208-src-win.zip
136K	./208/srpersist/srpersist-208-bin-i386-win32.plt
144K	./208/srpersist/srpersist-208-src-all.plt
1.3M	./209/libs/libs-209-bin-i386-win32.exe
1.4M	./209/libs/libs-209-bin-ppc-osx-mac.dmg
2.7M	./209/mz/mz-209-bin-i386-freebsd.sh
2.8M	./209/mz/mz-209-bin-i386-linux-debian-testing.sh
2.8M	./209/mz/mz-209-bin-i386-linux-debian.sh
2.8M	./209/mz/mz-209-bin-i386-linux-gcc2.sh
2.8M	./209/mz/mz-209-bin-i386-linux.sh
2.5M	./209/mz/mz-209-bin-i386-win32.exe
2.7M	./209/mz/mz-209-bin-ppc-darwin.sh
2.8M	./209/mz/mz-209-bin-ppc-osx-mac.dmg
3.2M	./209/mz/mz-209-bin-sparc-solaris.sh
3.1M	./209/mz/mz-209-src-mac.dmg
2.9M	./209/mz/mz-209-src-unix.tgz
3.3M	./209/mz/mz-209-src-win.zip
12M	./209/plt/plt-209-bin-i386-freebsd.sh
12M	./209/plt/plt-209-bin-i386-linux-debian-testing.sh
12M	./209/plt/plt-209-bin-i386-linux-debian.sh
12M	./209/plt/plt-209-bin-i386-linux-gcc2.sh
12M	./209/plt/plt-209-bin-i386-linux.sh
8.4M	./209/plt/plt-209-bin-i386-win32.exe
12M	./209/plt/plt-209-bin-ppc-darwin.sh
12M	./209/plt/plt-209-bin-ppc-osx-mac.dmg
13M	./209/plt/plt-209-bin-sparc-solaris.sh
11M	./209/plt/plt-209-src-mac.dmg
11M	./209/plt/plt-209-src-unix.tgz
13M	./209/plt/plt-209-src-win.zip
136K	./209/srpersist/srpersist-209-bin-i386-win32.plt
144K	./209/srpersist/srpersist-209-src-all.plt
1.7M	./300/libs/libs-300-bin-i386-win32.exe
1.6M	./300/libs/libs-300-bin-ppc-osx-mac.dmg
4.2M	./300/mz/mz-300-bin-i386-freebsd.sh
4.2M	./300/mz/mz-300-bin-i386-linux-debian-unstable.sh
4.2M	./300/mz/mz-300-bin-i386-linux-ubuntu.sh
4.2M	./300/mz/mz-300-bin-i386-linux-ubuntu510.sh
4.2M	./300/mz/mz-300-bin-i386-linux.sh
3.6M	./300/mz/mz-300-bin-i386-win32.exe
4.2M	./300/mz/mz-300-bin-ppc-darwin.sh
4.3M	./300/mz/mz-300-bin-ppc-osx-mac.dmg
4.6M	./300/mz/mz-300-bin-sparc-solaris.sh
4.0M	./300/mz/mz-300-src-mac.dmg
3.8M	./300/mz/mz-300-src-unix.tgz
3.9M	./300/mz/mz-300-src-win.zip
16M	./300/plt/plt-300-bin-i386-freebsd.sh
16M	./300/plt/plt-300-bin-i386-linux-debian-unstable.sh
16M	./300/plt/plt-300-bin-i386-linux-ubuntu.sh
16M	./300/plt/plt-300-bin-i386-linux-ubuntu510.sh
16M	./300/plt/plt-300-bin-i386-linux.sh
12M	./300/plt/plt-300-bin-i386-win32.exe
16M	./300/plt/plt-300-bin-ppc-darwin.sh
16M	./300/plt/plt-300-bin-ppc-osx-mac.dmg
17M	./300/plt/plt-300-bin-sparc-solaris.sh
13M	./300/plt/plt-300-src-mac.dmg
13M	./300/plt/plt-300-src-unix.tgz
14M	./300/plt/plt-300-src-win.zip
1.7M	./301/libs/libs-301-bin-i386-win32.exe
1.6M	./301/libs/libs-301-bin-ppc-osx-mac.dmg
4.2M	./301/mz/mz-301-bin-i386-freebsd.sh
4.2M	./301/mz/mz-301-bin-i386-linux-debian-unstable.sh
4.2M	./301/mz/mz-301-bin-i386-linux-ubuntu.sh
4.2M	./301/mz/mz-301-bin-i386-linux-ubuntu510.sh
4.2M	./301/mz/mz-301-bin-i386-linux.sh
3.7M	./301/mz/mz-301-bin-i386-win32.exe
4.2M	./301/mz/mz-301-bin-ppc-darwin.sh
4.3M	./301/mz/mz-301-bin-ppc-osx-mac.dmg
4.6M	./301/mz/mz-301-bin-sparc-solaris.sh
4.0M	./301/mz/mz-301-src-mac.dmg
3.8M	./301/mz/mz-301-src-unix.tgz
3.9M	./301/mz/mz-301-src-win.zip
16M	./301/plt/plt-301-bin-i386-freebsd.sh
16M	./301/plt/plt-301-bin-i386-linux-debian-unstable.sh
16M	./301/plt/plt-301-bin-i386-linux-ubuntu.sh
16M	./301/plt/plt-301-bin-i386-linux-ubuntu510.sh
16M	./301/plt/plt-301-bin-i386-linux.sh
12M	./301/plt/plt-301-bin-i386-win32.exe
16M	./301/plt/plt-301-bin-ppc-darwin.sh
16M	./301/plt/plt-301-bin-ppc-osx-mac.dmg
17M	./301/plt/plt-301-bin-sparc-solaris.sh
13M	./301/plt/plt-301-src-mac.dmg
13M	./301/plt/plt-301-src-unix.tgz
14M	./301/plt/plt-301-src-win.zip
4.1M	./350/mz/mz-350-bin-i386-freebsd.sh
4.1M	./350/mz/mz-350-bin-i386-linux-debian-unstable.sh
4.1M	./350/mz/mz-350-bin-i386-linux-ubuntu-dapper.sh
4.1M	./350/mz/mz-350-bin-i386-linux-ubuntu.sh
4.1M	./350/mz/mz-350-bin-i386-linux.sh
4.3M	./350/mz/mz-350-bin-i386-osx-mac.dmg
4.1M	./350/mz/mz-350-bin-i386-win32.exe
4.1M	./350/mz/mz-350-bin-ppc-darwin.sh
4.3M	./350/mz/mz-350-bin-ppc-osx-mac.dmg
4.1M	./350/mz/mz-350-bin-sparc-solaris.sh
4.2M	./350/mz/mz-350-src-mac.dmg
3.9M	./350/mz/mz-350-src-unix.tgz
4.1M	./350/mz/mz-350-src-win.zip
15M	./350/plt/plt-350-bin-i386-freebsd.sh
15M	./350/plt/plt-350-bin-i386-linux-debian-unstable.sh
15M	./350/plt/plt-350-bin-i386-linux-ubuntu-dapper.sh
15M	./350/plt/plt-350-bin-i386-linux-ubuntu.sh
15M	./350/plt/plt-350-bin-i386-linux.sh
16M	./350/plt/plt-350-bin-i386-osx-mac.dmg
12M	./350/plt/plt-350-bin-i386-win32.exe
15M	./350/plt/plt-350-bin-ppc-darwin.sh
16M	./350/plt/plt-350-bin-ppc-osx-mac.dmg
15M	./350/plt/plt-350-bin-sparc-solaris.sh
14M	./350/plt/plt-350-src-mac.dmg
13M	./350/plt/plt-350-src-unix.tgz
15M	./350/plt/plt-350-src-win.zip
4.2M	./351/mz/mz-351-bin-i386-freebsd.sh
4.3M	./351/mz/mz-351-bin-i386-linux-debian-unstable.sh
4.2M	./351/mz/mz-351-bin-i386-linux-ubuntu-dapper.sh
4.2M	./351/mz/mz-351-bin-i386-linux-ubuntu.sh
4.2M	./351/mz/mz-351-bin-i386-linux.sh
6.2M	./351/mz/mz-351-bin-i386-osx-mac.dmg
4.2M	./351/mz/mz-351-bin-i386-win32.exe
4.2M	./351/mz/mz-351-bin-ppc-darwin.sh
6.2M	./351/mz/mz-351-bin-ppc-osx-mac.dmg
4.2M	./351/mz/mz-351-bin-sparc-solaris.sh
5.3M	./351/mz/mz-351-src-mac.dmg
4.0M	./351/mz/mz-351-src-unix.tgz
4.1M	./351/mz/mz-351-src-win.zip
16M	./351/plt/plt-351-bin-i386-freebsd.sh
16M	./351/plt/plt-351-bin-i386-linux-debian-unstable.sh
15M	./351/plt/plt-351-bin-i386-linux-ubuntu-dapper.sh
16M	./351/plt/plt-351-bin-i386-linux-ubuntu.sh
15M	./351/plt/plt-351-bin-i386-linux.sh
22M	./351/plt/plt-351-bin-i386-osx-mac.dmg
12M	./351/plt/plt-351-bin-i386-win32.exe
16M	./351/plt/plt-351-bin-ppc-darwin.sh
23M	./351/plt/plt-351-bin-ppc-osx-mac.dmg
16M	./351/plt/plt-351-bin-sparc-solaris.sh
18M	./351/plt/plt-351-src-mac.dmg
13M	./351/plt/plt-351-src-unix.tgz
15M	./351/plt/plt-351-src-win.zip
4.2M	./352/mz/mz-352-bin-i386-freebsd.sh
4.3M	./352/mz/mz-352-bin-i386-linux-debian-unstable.sh
4.2M	./352/mz/mz-352-bin-i386-linux-ubuntu-dapper.sh
4.2M	./352/mz/mz-352-bin-i386-linux-ubuntu.sh
4.2M	./352/mz/mz-352-bin-i386-linux.sh
4.4M	./352/mz/mz-352-bin-i386-osx-mac.dmg
4.2M	./352/mz/mz-352-bin-i386-win32.exe
4.2M	./352/mz/mz-352-bin-ppc-darwin.sh
4.5M	./352/mz/mz-352-bin-ppc-osx-mac.dmg
4.2M	./352/mz/mz-352-bin-sparc-solaris.sh
4.2M	./352/mz/mz-352-src-mac.dmg
4.0M	./352/mz/mz-352-src-unix.tgz
4.1M	./352/mz/mz-352-src-win.zip
16M	./352/plt/plt-352-bin-i386-freebsd.sh
16M	./352/plt/plt-352-bin-i386-linux-debian-unstable.sh
15M	./352/plt/plt-352-bin-i386-linux-ubuntu-dapper.sh
16M	./352/plt/plt-352-bin-i386-linux-ubuntu.sh
15M	./352/plt/plt-352-bin-i386-linux.sh
16M	./352/plt/plt-352-bin-i386-osx-mac.dmg
12M	./352/plt/plt-352-bin-i386-win32.exe
16M	./352/plt/plt-352-bin-ppc-darwin.sh
17M	./352/plt/plt-352-bin-ppc-osx-mac.dmg
16M	./352/plt/plt-352-bin-sparc-solaris.sh
14M	./352/plt/plt-352-src-mac.dmg
14M	./352/plt/plt-352-src-unix.tgz
15M	./352/plt/plt-352-src-win.zip
4.4M	./360/mz/mz-360-bin-i386-linux-debian-unstable.sh
4.3M	./360/mz/mz-360-bin-i386-linux-fc2.sh
4.3M	./360/mz/mz-360-bin-i386-linux-fc5.sh
4.3M	./360/mz/mz-360-bin-i386-linux-ubuntu-edgy.sh
4.4M	./360/mz/mz-360-bin-i386-linux-ubuntu.sh
4.5M	./360/mz/mz-360-bin-i386-osx-mac.dmg
4.3M	./360/mz/mz-360-bin-i386-win32.exe
4.3M	./360/mz/mz-360-bin-ppc-darwin.sh
4.5M	./360/mz/mz-360-bin-ppc-osx-mac.dmg
4.3M	./360/mz/mz-360-bin-sparc-solaris.sh
4.3M	./360/mz/mz-360-src-mac.dmg
4.1M	./360/mz/mz-360-src-unix.tgz
5.5M	./360/mz/mz-360-src-win.zip
16M	./360/plt/plt-360-bin-i386-linux-debian-unstable.sh
16M	./360/plt/plt-360-bin-i386-linux-fc2.sh
16M	./360/plt/plt-360-bin-i386-linux-fc5.sh
16M	./360/plt/plt-360-bin-i386-linux-ubuntu-edgy.sh
16M	./360/plt/plt-360-bin-i386-linux-ubuntu.sh
17M	./360/plt/plt-360-bin-i386-osx-mac.dmg
13M	./360/plt/plt-360-bin-i386-win32.exe
16M	./360/plt/plt-360-bin-ppc-darwin.sh
17M	./360/plt/plt-360-bin-ppc-osx-mac.dmg
16M	./360/plt/plt-360-bin-sparc-solaris.sh
14M	./360/plt/plt-360-src-mac.dmg
14M	./360/plt/plt-360-src-unix.tgz
17M	./360/plt/plt-360-src-win.zip
4.8M	./370/mz/mz-370-bin-i386-linux-debian-unstable.sh
4.7M	./370/mz/mz-370-bin-i386-linux-fc6.sh
4.8M	./370/mz/mz-370-bin-i386-linux-ubuntu-feisty.sh
4.8M	./370/mz/mz-370-bin-i386-linux-ubuntu.sh
4.9M	./370/mz/mz-370-bin-i386-osx-mac.dmg
4.6M	./370/mz/mz-370-bin-i386-win32.exe
4.8M	./370/mz/mz-370-bin-ppc-darwin.sh
5.0M	./370/mz/mz-370-bin-ppc-osx-mac.dmg
4.7M	./370/mz/mz-370-bin-sparc-solaris.sh
4.3M	./370/mz/mz-370-src-mac.dmg
4.2M	./370/mz/mz-370-src-unix.tgz
5.6M	./370/mz/mz-370-src-win.zip
17M	./370/plt/plt-370-bin-i386-linux-debian-unstable.sh
17M	./370/plt/plt-370-bin-i386-linux-fc6.sh
17M	./370/plt/plt-370-bin-i386-linux-ubuntu-feisty.sh
17M	./370/plt/plt-370-bin-i386-linux-ubuntu.sh
18M	./370/plt/plt-370-bin-i386-osx-mac.dmg
13M	./370/plt/plt-370-bin-i386-win32.exe
17M	./370/plt/plt-370-bin-ppc-darwin.sh
18M	./370/plt/plt-370-bin-ppc-osx-mac.dmg
17M	./370/plt/plt-370-bin-sparc-solaris.sh
15M	./370/plt/plt-370-src-mac.dmg
14M	./370/plt/plt-370-src-unix.tgz
17M	./370/plt/plt-370-src-win.zip
4.9M	./371/mz/mz-371-bin-i386-linux-debian-unstable.sh
4.9M	./371/mz/mz-371-bin-i386-linux-fc6.sh
4.9M	./371/mz/mz-371-bin-i386-linux-ubuntu-feisty.sh
4.8M	./371/mz/mz-371-bin-i386-linux-ubuntu.sh
5.1M	./371/mz/mz-371-bin-i386-osx-mac.dmg
4.6M	./371/mz/mz-371-bin-i386-win32.exe
4.9M	./371/mz/mz-371-bin-ppc-darwin.sh
5.2M	./371/mz/mz-371-bin-ppc-osx-mac.dmg
4.9M	./371/mz/mz-371-bin-sparc-solaris.sh
6.1M	./371/mz/mz-371-bin-x86_64-linux-f7.sh
4.4M	./371/mz/mz-371-src-mac.dmg
4.2M	./371/mz/mz-371-src-unix.tgz
5.7M	./371/mz/mz-371-src-win.zip
18M	./371/plt/plt-371-bin-i386-linux-debian-unstable.sh
18M	./371/plt/plt-371-bin-i386-linux-fc6.sh
18M	./371/plt/plt-371-bin-i386-linux-ubuntu-feisty.sh
18M	./371/plt/plt-371-bin-i386-linux-ubuntu.sh
19M	./371/plt/plt-371-bin-i386-osx-mac.dmg
14M	./371/plt/plt-371-bin-i386-win32.exe
18M	./371/plt/plt-371-bin-ppc-darwin.sh
19M	./371/plt/plt-371-bin-ppc-osx-mac.dmg
18M	./371/plt/plt-371-bin-sparc-solaris.sh
22M	./371/plt/plt-371-bin-x86_64-linux-f7.sh
15M	./371/plt/plt-371-src-mac.dmg
15M	./371/plt/plt-371-src-unix.tgz
18M	./371/plt/plt-371-src-win.zip
5.2M	./372/mz/mz-372-bin-i386-linux-fc6.sh
5.2M	./372/mz/mz-372-bin-i386-linux-ubuntu-feisty.sh
5.1M	./372/mz/mz-372-bin-i386-linux-ubuntu.sh
5.4M	./372/mz/mz-372-bin-i386-osx-mac.dmg
4.8M	./372/mz/mz-372-bin-i386-win32.exe
5.2M	./372/mz/mz-372-bin-ppc-darwin.sh
5.5M	./372/mz/mz-372-bin-ppc-osx-mac.dmg
5.2M	./372/mz/mz-372-bin-sparc-solaris.sh
5.3M	./372/mz/mz-372-bin-x86_64-linux-f7.sh
4.5M	./372/mz/mz-372-src-mac.dmg
4.3M	./372/mz/mz-372-src-unix.tgz
5.8M	./372/mz/mz-372-src-win.zip
18M	./372/plt/plt-372-bin-i386-linux-fc6.sh
18M	./372/plt/plt-372-bin-i386-linux-ubuntu-feisty.sh
18M	./372/plt/plt-372-bin-i386-linux-ubuntu.sh
19M	./372/plt/plt-372-bin-i386-osx-mac.dmg
14M	./372/plt/plt-372-bin-i386-win32.exe
18M	./372/plt/plt-372-bin-ppc-darwin.sh
19M	./372/plt/plt-372-bin-ppc-osx-mac.dmg
18M	./372/plt/plt-372-bin-sparc-solaris.sh
19M	./372/plt/plt-372-bin-x86_64-linux-f7.sh
15M	./372/plt/plt-372-src-mac.dmg
15M	./372/plt/plt-372-src-unix.tgz
18M	./372/plt/plt-372-src-win.zip
5.9M	./4.0.1/mz/mz-4.0.1-bin-i386-linux-f9.sh
5.9M	./4.0.1/mz/mz-4.0.1-bin-i386-linux-ubuntu-feisty.sh
5.9M	./4.0.1/mz/mz-4.0.1-bin-i386-linux-ubuntu.sh
6.2M	./4.0.1/mz/mz-4.0.1-bin-i386-osx-mac.dmg
5.2M	./4.0.1/mz/mz-4.0.1-bin-i386-win32.exe
5.9M	./4.0.1/mz/mz-4.0.1-bin-ppc-darwin.sh
6.2M	./4.0.1/mz/mz-4.0.1-bin-ppc-osx-mac.dmg
5.9M	./4.0.1/mz/mz-4.0.1-bin-sparc-solaris.sh
6.0M	./4.0.1/mz/mz-4.0.1-bin-x86_64-linux-f7.sh
4.5M	./4.0.1/mz/mz-4.0.1-src-mac.dmg
4.4M	./4.0.1/mz/mz-4.0.1-src-unix.tgz
5.8M	./4.0.1/mz/mz-4.0.1-src-win.zip
36M	./4.0.1/plt/plt-4.0.1-bin-i386-linux-f9.sh
36M	./4.0.1/plt/plt-4.0.1-bin-i386-linux-ubuntu-feisty.sh
36M	./4.0.1/plt/plt-4.0.1-bin-i386-linux-ubuntu.sh
38M	./4.0.1/plt/plt-4.0.1-bin-i386-osx-mac.dmg
22M	./4.0.1/plt/plt-4.0.1-bin-i386-win32.exe
36M	./4.0.1/plt/plt-4.0.1-bin-ppc-darwin.sh
38M	./4.0.1/plt/plt-4.0.1-bin-ppc-osx-mac.dmg
36M	./4.0.1/plt/plt-4.0.1-bin-sparc-solaris.sh
37M	./4.0.1/plt/plt-4.0.1-bin-x86_64-linux-f7.sh
15M	./4.0.1/plt/plt-4.0.1-src-mac.dmg
14M	./4.0.1/plt/plt-4.0.1-src-unix.tgz
17M	./4.0.1/plt/plt-4.0.1-src-win.zip
5.9M	./4.0.2/mz/mz-4.0.2-bin-i386-linux-f9.sh
5.9M	./4.0.2/mz/mz-4.0.2-bin-i386-linux-ubuntu-feisty.sh
5.9M	./4.0.2/mz/mz-4.0.2-bin-i386-linux-ubuntu.sh
6.2M	./4.0.2/mz/mz-4.0.2-bin-i386-osx-mac.dmg
5.2M	./4.0.2/mz/mz-4.0.2-bin-i386-win32.exe
5.9M	./4.0.2/mz/mz-4.0.2-bin-ppc-darwin.sh
6.2M	./4.0.2/mz/mz-4.0.2-bin-ppc-osx-mac.dmg
5.9M	./4.0.2/mz/mz-4.0.2-bin-sparc-solaris.sh
6.0M	./4.0.2/mz/mz-4.0.2-bin-x86_64-linux-f7.sh
4.5M	./4.0.2/mz/mz-4.0.2-src-mac.dmg
4.4M	./4.0.2/mz/mz-4.0.2-src-unix.tgz
5.8M	./4.0.2/mz/mz-4.0.2-src-win.zip
36M	./4.0.2/plt/plt-4.0.2-bin-i386-linux-f9.sh
36M	./4.0.2/plt/plt-4.0.2-bin-i386-linux-ubuntu-feisty.sh
36M	./4.0.2/plt/plt-4.0.2-bin-i386-linux-ubuntu.sh
38M	./4.0.2/plt/plt-4.0.2-bin-i386-osx-mac.dmg
22M	./4.0.2/plt/plt-4.0.2-bin-i386-win32.exe
36M	./4.0.2/plt/plt-4.0.2-bin-ppc-darwin.sh
38M	./4.0.2/plt/plt-4.0.2-bin-ppc-osx-mac.dmg
36M	./4.0.2/plt/plt-4.0.2-bin-sparc-solaris.sh
37M	./4.0.2/plt/plt-4.0.2-bin-x86_64-linux-f7.sh
15M	./4.0.2/plt/plt-4.0.2-src-mac.dmg
14M	./4.0.2/plt/plt-4.0.2-src-unix.tgz
17M	./4.0.2/plt/plt-4.0.2-src-win.zip
5.9M	./4.0/mz/mz-4.0-bin-i386-linux-f9.sh
5.9M	./4.0/mz/mz-4.0-bin-i386-linux-ubuntu-feisty.sh
5.8M	./4.0/mz/mz-4.0-bin-i386-linux-ubuntu.sh
6.2M	./4.0/mz/mz-4.0-bin-i386-osx-mac.dmg
5.2M	./4.0/mz/mz-4.0-bin-i386-win32.exe
5.9M	./4.0/mz/mz-4.0-bin-ppc-darwin.sh
6.2M	./4.0/mz/mz-4.0-bin-ppc-osx-mac.dmg
5.9M	./4.0/mz/mz-4.0-bin-sparc-solaris.sh
6.0M	./4.0/mz/mz-4.0-bin-x86_64-linux-f7.sh
4.5M	./4.0/mz/mz-4.0-src-mac.dmg
4.4M	./4.0/mz/mz-4.0-src-unix.tgz
5.7M	./4.0/mz/mz-4.0-src-win.zip
36M	./4.0/plt/plt-4.0-bin-i386-linux-f9.sh
36M	./4.0/plt/plt-4.0-bin-i386-linux-ubuntu-feisty.sh
36M	./4.0/plt/plt-4.0-bin-i386-linux-ubuntu.sh
38M	./4.0/plt/plt-4.0-bin-i386-osx-mac.dmg
22M	./4.0/plt/plt-4.0-bin-i386-win32.exe
36M	./4.0/plt/plt-4.0-bin-ppc-darwin.sh
38M	./4.0/plt/plt-4.0-bin-ppc-osx-mac.dmg
36M	./4.0/plt/plt-4.0-bin-sparc-solaris.sh
37M	./4.0/plt/plt-4.0-bin-x86_64-linux-f7.sh
15M	./4.0/plt/plt-4.0-src-mac.dmg
14M	./4.0/plt/plt-4.0-src-unix.tgz
17M	./4.0/plt/plt-4.0-src-win.zip
6.2M	./4.1.1/mz/mz-4.1.1-bin-i386-linux-f9.sh
6.2M	./4.1.1/mz/mz-4.1.1-bin-i386-linux-ubuntu-feisty.sh
6.2M	./4.1.1/mz/mz-4.1.1-bin-i386-linux-ubuntu.sh
6.4M	./4.1.1/mz/mz-4.1.1-bin-i386-osx-mac.dmg
5.3M	./4.1.1/mz/mz-4.1.1-bin-i386-win32.exe
6.2M	./4.1.1/mz/mz-4.1.1-bin-ppc-darwin.sh
6.4M	./4.1.1/mz/mz-4.1.1-bin-ppc-osx-mac.dmg
6.2M	./4.1.1/mz/mz-4.1.1-bin-sparc-solaris.sh
6.3M	./4.1.1/mz/mz-4.1.1-bin-x86_64-linux-f7.sh
4.5M	./4.1.1/mz/mz-4.1.1-src-mac.dmg
4.4M	./4.1.1/mz/mz-4.1.1-src-unix.tgz
5.8M	./4.1.1/mz/mz-4.1.1-src-win.zip
38M	./4.1.1/plt/plt-4.1.1-bin-i386-linux-f9.sh
38M	./4.1.1/plt/plt-4.1.1-bin-i386-linux-ubuntu-feisty.sh
38M	./4.1.1/plt/plt-4.1.1-bin-i386-linux-ubuntu.sh
39M	./4.1.1/plt/plt-4.1.1-bin-i386-osx-mac.dmg
23M	./4.1.1/plt/plt-4.1.1-bin-i386-win32.exe
38M	./4.1.1/plt/plt-4.1.1-bin-ppc-darwin.sh
39M	./4.1.1/plt/plt-4.1.1-bin-ppc-osx-mac.dmg
38M	./4.1.1/plt/plt-4.1.1-bin-sparc-solaris.sh
38M	./4.1.1/plt/plt-4.1.1-bin-x86_64-linux-f7.sh
14M	./4.1.1/plt/plt-4.1.1-src-mac.dmg
14M	./4.1.1/plt/plt-4.1.1-src-unix.tgz
17M	./4.1.1/plt/plt-4.1.1-src-win.zip
6.2M	./4.1.2/mz/mz-4.1.2-bin-i386-linux-f9.sh
6.2M	./4.1.2/mz/mz-4.1.2-bin-i386-linux-ubuntu-feisty.sh
6.2M	./4.1.2/mz/mz-4.1.2-bin-i386-linux-ubuntu.sh
6.4M	./4.1.2/mz/mz-4.1.2-bin-i386-osx-mac.dmg
5.3M	./4.1.2/mz/mz-4.1.2-bin-i386-win32.exe
6.2M	./4.1.2/mz/mz-4.1.2-bin-ppc-darwin.sh
6.4M	./4.1.2/mz/mz-4.1.2-bin-ppc-osx-mac.dmg
6.2M	./4.1.2/mz/mz-4.1.2-bin-sparc-solaris.sh
6.3M	./4.1.2/mz/mz-4.1.2-bin-x86_64-linux-f7.sh
4.5M	./4.1.2/mz/mz-4.1.2-src-mac.dmg
4.4M	./4.1.2/mz/mz-4.1.2-src-unix.tgz
5.8M	./4.1.2/mz/mz-4.1.2-src-win.zip
38M	./4.1.2/plt/plt-4.1.2-bin-i386-linux-f9.sh
38M	./4.1.2/plt/plt-4.1.2-bin-i386-linux-ubuntu-feisty.sh
38M	./4.1.2/plt/plt-4.1.2-bin-i386-linux-ubuntu.sh
39M	./4.1.2/plt/plt-4.1.2-bin-i386-osx-mac.dmg
23M	./4.1.2/plt/plt-4.1.2-bin-i386-win32.exe
38M	./4.1.2/plt/plt-4.1.2-bin-ppc-darwin.sh
39M	./4.1.2/plt/plt-4.1.2-bin-ppc-osx-mac.dmg
38M	./4.1.2/plt/plt-4.1.2-bin-sparc-solaris.sh
39M	./4.1.2/plt/plt-4.1.2-bin-x86_64-linux-f7.sh
14M	./4.1.2/plt/plt-4.1.2-src-mac.dmg
14M	./4.1.2/plt/plt-4.1.2-src-unix.tgz
17M	./4.1.2/plt/plt-4.1.2-src-win.zip
6.1M	./4.1.3/mz/mz-4.1.3-bin-i386-linux-f9.sh
6.1M	./4.1.3/mz/mz-4.1.3-bin-i386-linux-ubuntu-feisty.sh
6.1M	./4.1.3/mz/mz-4.1.3-bin-i386-linux-ubuntu.sh
6.3M	./4.1.3/mz/mz-4.1.3-bin-i386-osx-mac.dmg
5.3M	./4.1.3/mz/mz-4.1.3-bin-i386-win32.exe
6.1M	./4.1.3/mz/mz-4.1.3-bin-ppc-darwin.sh
6.3M	./4.1.3/mz/mz-4.1.3-bin-ppc-osx-mac.dmg
6.1M	./4.1.3/mz/mz-4.1.3-bin-sparc-solaris.sh
6.2M	./4.1.3/mz/mz-4.1.3-bin-x86_64-linux-f7.sh
4.5M	./4.1.3/mz/mz-4.1.3-src-mac.dmg
4.4M	./4.1.3/mz/mz-4.1.3-src-unix.tgz
5.8M	./4.1.3/mz/mz-4.1.3-src-win.zip
33M	./4.1.3/plt/plt-4.1.3-bin-i386-linux-f9.sh
33M	./4.1.3/plt/plt-4.1.3-bin-i386-linux-ubuntu-feisty.sh
33M	./4.1.3/plt/plt-4.1.3-bin-i386-linux-ubuntu.sh
34M	./4.1.3/plt/plt-4.1.3-bin-i386-osx-mac.dmg
22M	./4.1.3/plt/plt-4.1.3-bin-i386-win32.exe
33M	./4.1.3/plt/plt-4.1.3-bin-ppc-darwin.sh
34M	./4.1.3/plt/plt-4.1.3-bin-ppc-osx-mac.dmg
33M	./4.1.3/plt/plt-4.1.3-bin-sparc-solaris.sh
34M	./4.1.3/plt/plt-4.1.3-bin-x86_64-linux-f7.sh
15M	./4.1.3/plt/plt-4.1.3-src-mac.dmg
14M	./4.1.3/plt/plt-4.1.3-src-unix.tgz
17M	./4.1.3/plt/plt-4.1.3-src-win.zip
6.4M	./4.1.4/mz/mz-4.1.4-bin-i386-linux-f9.sh
6.3M	./4.1.4/mz/mz-4.1.4-bin-i386-linux-ubuntu-feisty.sh
6.3M	./4.1.4/mz/mz-4.1.4-bin-i386-linux-ubuntu.sh
6.5M	./4.1.4/mz/mz-4.1.4-bin-i386-osx-mac.dmg
5.4M	./4.1.4/mz/mz-4.1.4-bin-i386-win32.exe
6.4M	./4.1.4/mz/mz-4.1.4-bin-ppc-darwin.sh
6.6M	./4.1.4/mz/mz-4.1.4-bin-ppc-osx-mac.dmg
6.3M	./4.1.4/mz/mz-4.1.4-bin-sparc-solaris.sh
6.5M	./4.1.4/mz/mz-4.1.4-bin-x86_64-linux-f7.sh
4.6M	./4.1.4/mz/mz-4.1.4-src-mac.dmg
4.5M	./4.1.4/mz/mz-4.1.4-src-unix.tgz
5.9M	./4.1.4/mz/mz-4.1.4-src-win.zip
36M	./4.1.4/plt/plt-4.1.4-bin-i386-linux-f9.sh
36M	./4.1.4/plt/plt-4.1.4-bin-i386-linux-ubuntu-feisty.sh
36M	./4.1.4/plt/plt-4.1.4-bin-i386-linux-ubuntu.sh
37M	./4.1.4/plt/plt-4.1.4-bin-i386-osx-mac.dmg
23M	./4.1.4/plt/plt-4.1.4-bin-i386-win32.exe
36M	./4.1.4/plt/plt-4.1.4-bin-ppc-darwin.sh
37M	./4.1.4/plt/plt-4.1.4-bin-ppc-osx-mac.dmg
36M	./4.1.4/plt/plt-4.1.4-bin-sparc-solaris.sh
36M	./4.1.4/plt/plt-4.1.4-bin-x86_64-linux-f7.sh
15M	./4.1.4/plt/plt-4.1.4-src-mac.dmg
15M	./4.1.4/plt/plt-4.1.4-src-unix.tgz
18M	./4.1.4/plt/plt-4.1.4-src-win.zip
6.9M	./4.1.5/mz/mz-4.1.5-bin-i386-linux-f9.sh
6.9M	./4.1.5/mz/mz-4.1.5-bin-i386-linux-ubuntu-intrepid.sh
6.9M	./4.1.5/mz/mz-4.1.5-bin-i386-linux-ubuntu.sh
7.1M	./4.1.5/mz/mz-4.1.5-bin-i386-osx-mac.dmg
5.8M	./4.1.5/mz/mz-4.1.5-bin-i386-win32.exe
6.9M	./4.1.5/mz/mz-4.1.5-bin-ppc-darwin.sh
7.1M	./4.1.5/mz/mz-4.1.5-bin-ppc-osx-mac.dmg
6.9M	./4.1.5/mz/mz-4.1.5-bin-sparc-solaris.sh
7.0M	./4.1.5/mz/mz-4.1.5-bin-x86_64-linux-f7.sh
4.6M	./4.1.5/mz/mz-4.1.5-src-mac.dmg
4.5M	./4.1.5/mz/mz-4.1.5-src-unix.tgz
6.0M	./4.1.5/mz/mz-4.1.5-src-win.zip
38M	./4.1.5/plt/plt-4.1.5-bin-i386-linux-f9.sh
38M	./4.1.5/plt/plt-4.1.5-bin-i386-linux-ubuntu-intrepid.sh
38M	./4.1.5/plt/plt-4.1.5-bin-i386-linux-ubuntu.sh
39M	./4.1.5/plt/plt-4.1.5-bin-i386-osx-mac.dmg
25M	./4.1.5/plt/plt-4.1.5-bin-i386-win32.exe
38M	./4.1.5/plt/plt-4.1.5-bin-ppc-darwin.sh
39M	./4.1.5/plt/plt-4.1.5-bin-ppc-osx-mac.dmg
38M	./4.1.5/plt/plt-4.1.5-bin-sparc-solaris.sh
39M	./4.1.5/plt/plt-4.1.5-bin-x86_64-linux-f7.sh
15M	./4.1.5/plt/plt-4.1.5-src-mac.dmg
15M	./4.1.5/plt/plt-4.1.5-src-unix.tgz
18M	./4.1.5/plt/plt-4.1.5-src-win.zip
6.1M	./4.1/mz/mz-4.1-bin-i386-linux-f9.sh
6.1M	./4.1/mz/mz-4.1-bin-i386-linux-ubuntu-feisty.sh
6.1M	./4.1/mz/mz-4.1-bin-i386-linux-ubuntu.sh
6.3M	./4.1/mz/mz-4.1-bin-i386-osx-mac.dmg
5.3M	./4.1/mz/mz-4.1-bin-i386-win32.exe
6.1M	./4.1/mz/mz-4.1-bin-ppc-darwin.sh
6.3M	./4.1/mz/mz-4.1-bin-ppc-osx-mac.dmg
6.0M	./4.1/mz/mz-4.1-bin-sparc-solaris.sh
6.2M	./4.1/mz/mz-4.1-bin-x86_64-linux-f7.sh
4.5M	./4.1/mz/mz-4.1-src-mac.dmg
4.4M	./4.1/mz/mz-4.1-src-unix.tgz
5.8M	./4.1/mz/mz-4.1-src-win.zip
37M	./4.1/plt/plt-4.1-bin-i386-linux-f9.sh
37M	./4.1/plt/plt-4.1-bin-i386-linux-ubuntu-feisty.sh
37M	./4.1/plt/plt-4.1-bin-i386-linux-ubuntu.sh
38M	./4.1/plt/plt-4.1-bin-i386-osx-mac.dmg
22M	./4.1/plt/plt-4.1-bin-i386-win32.exe
37M	./4.1/plt/plt-4.1-bin-ppc-darwin.sh
38M	./4.1/plt/plt-4.1-bin-ppc-osx-mac.dmg
37M	./4.1/plt/plt-4.1-bin-sparc-solaris.sh
38M	./4.1/plt/plt-4.1-bin-x86_64-linux-f7.sh
15M	./4.1/plt/plt-4.1-src-mac.dmg
15M	./4.1/plt/plt-4.1-src-unix.tgz
17M	./4.1/plt/plt-4.1-src-win.zip
7.4M	./4.2.1/mz/mz-4.2.1-bin-i386-linux-f9.sh
7.4M	./4.2.1/mz/mz-4.2.1-bin-i386-linux-ubuntu-jaunty.sh
7.6M	./4.2.1/mz/mz-4.2.1-bin-i386-osx-mac.dmg
6.1M	./4.2.1/mz/mz-4.2.1-bin-i386-win32.exe
7.4M	./4.2.1/mz/mz-4.2.1-bin-ppc-darwin.sh
7.7M	./4.2.1/mz/mz-4.2.1-bin-ppc-osx-mac.dmg
7.4M	./4.2.1/mz/mz-4.2.1-bin-sparc-solaris.sh
7.6M	./4.2.1/mz/mz-4.2.1-bin-x86_64-linux-f7.sh
4.7M	./4.2.1/mz/mz-4.2.1-src-mac.dmg
4.6M	./4.2.1/mz/mz-4.2.1-src-unix.tgz
6.1M	./4.2.1/mz/mz-4.2.1-src-win.zip
39M	./4.2.1/plt/plt-4.2.1-bin-i386-linux-f9.sh
40M	./4.2.1/plt/plt-4.2.1-bin-i386-linux-ubuntu-jaunty.sh
40M	./4.2.1/plt/plt-4.2.1-bin-i386-osx-mac.dmg
25M	./4.2.1/plt/plt-4.2.1-bin-i386-win32.exe
40M	./4.2.1/plt/plt-4.2.1-bin-ppc-darwin.sh
41M	./4.2.1/plt/plt-4.2.1-bin-ppc-osx-mac.dmg
40M	./4.2.1/plt/plt-4.2.1-bin-sparc-solaris.sh
40M	./4.2.1/plt/plt-4.2.1-bin-x86_64-linux-f7.sh
15M	./4.2.1/plt/plt-4.2.1-src-mac.dmg
15M	./4.2.1/plt/plt-4.2.1-src-unix.tgz
18M	./4.2.1/plt/plt-4.2.1-src-win.zip
7.5M	./4.2.2/mz/mz-4.2.2-bin-i386-linux-f9.sh
7.5M	./4.2.2/mz/mz-4.2.2-bin-i386-linux-ubuntu-jaunty.sh
7.8M	./4.2.2/mz/mz-4.2.2-bin-i386-osx-mac.dmg
6.1M	./4.2.2/mz/mz-4.2.2-bin-i386-win32.exe
7.5M	./4.2.2/mz/mz-4.2.2-bin-ppc-darwin.sh
7.8M	./4.2.2/mz/mz-4.2.2-bin-ppc-osx-mac.dmg
7.7M	./4.2.2/mz/mz-4.2.2-bin-x86_64-linux-f7.sh
4.8M	./4.2.2/mz/mz-4.2.2-src-mac.dmg
4.7M	./4.2.2/mz/mz-4.2.2-src-unix.tgz
6.1M	./4.2.2/mz/mz-4.2.2-src-win.zip
39M	./4.2.2/plt/plt-4.2.2-bin-i386-linux-f9.sh
39M	./4.2.2/plt/plt-4.2.2-bin-i386-linux-ubuntu-jaunty.sh
40M	./4.2.2/plt/plt-4.2.2-bin-i386-osx-mac.dmg
25M	./4.2.2/plt/plt-4.2.2-bin-i386-win32.exe
39M	./4.2.2/plt/plt-4.2.2-bin-ppc-darwin.sh
40M	./4.2.2/plt/plt-4.2.2-bin-ppc-osx-mac.dmg
40M	./4.2.2/plt/plt-4.2.2-bin-x86_64-linux-f7.sh
15M	./4.2.2/plt/plt-4.2.2-src-mac.dmg
15M	./4.2.2/plt/plt-4.2.2-src-unix.tgz
18M	./4.2.2/plt/plt-4.2.2-src-win.zip
7.7M	./4.2.3/mz/mz-4.2.3-bin-i386-linux-f9.sh
7.7M	./4.2.3/mz/mz-4.2.3-bin-i386-linux-ubuntu-jaunty.sh
7.9M	./4.2.3/mz/mz-4.2.3-bin-i386-osx-mac.dmg
6.2M	./4.2.3/mz/mz-4.2.3-bin-i386-win32.exe
7.7M	./4.2.3/mz/mz-4.2.3-bin-ppc-darwin.sh
7.9M	./4.2.3/mz/mz-4.2.3-bin-ppc-osx-mac.dmg
7.8M	./4.2.3/mz/mz-4.2.3-bin-x86_64-linux-f7.sh
5.2M	./4.2.3/mz/mz-4.2.3-src-mac.dmg
5.0M	./4.2.3/mz/mz-4.2.3-src-unix.tgz
6.6M	./4.2.3/mz/mz-4.2.3-src-win.zip
40M	./4.2.3/plt/plt-4.2.3-bin-i386-linux-f9.sh
40M	./4.2.3/plt/plt-4.2.3-bin-i386-linux-ubuntu-jaunty.sh
41M	./4.2.3/plt/plt-4.2.3-bin-i386-osx-mac.dmg
26M	./4.2.3/plt/plt-4.2.3-bin-i386-win32.exe
40M	./4.2.3/plt/plt-4.2.3-bin-ppc-darwin.sh
41M	./4.2.3/plt/plt-4.2.3-bin-ppc-osx-mac.dmg
41M	./4.2.3/plt/plt-4.2.3-bin-x86_64-linux-f7.sh
16M	./4.2.3/plt/plt-4.2.3-src-mac.dmg
16M	./4.2.3/plt/plt-4.2.3-src-unix.tgz
19M	./4.2.3/plt/plt-4.2.3-src-win.zip
7.8M	./4.2.4/mz/mz-4.2.4-bin-i386-linux-f12.sh
7.8M	./4.2.4/mz/mz-4.2.4-bin-i386-linux-ubuntu-jaunty.sh
8.1M	./4.2.4/mz/mz-4.2.4-bin-i386-osx-mac.dmg
6.3M	./4.2.4/mz/mz-4.2.4-bin-i386-win32.exe
7.8M	./4.2.4/mz/mz-4.2.4-bin-ppc-darwin.sh
8.1M	./4.2.4/mz/mz-4.2.4-bin-ppc-osx-mac.dmg
8.0M	./4.2.4/mz/mz-4.2.4-bin-x86_64-linux-f7.sh
5.2M	./4.2.4/mz/mz-4.2.4-src-mac.dmg
5.1M	./4.2.4/mz/mz-4.2.4-src-unix.tgz
6.6M	./4.2.4/mz/mz-4.2.4-src-win.zip
41M	./4.2.4/plt/plt-4.2.4-bin-i386-linux-f12.sh
41M	./4.2.4/plt/plt-4.2.4-bin-i386-linux-ubuntu-jaunty.sh
42M	./4.2.4/plt/plt-4.2.4-bin-i386-osx-mac.dmg
26M	./4.2.4/plt/plt-4.2.4-bin-i386-win32.exe
41M	./4.2.4/plt/plt-4.2.4-bin-ppc-darwin.sh
42M	./4.2.4/plt/plt-4.2.4-bin-ppc-osx-mac.dmg
41M	./4.2.4/plt/plt-4.2.4-bin-x86_64-linux-f7.sh
16M	./4.2.4/plt/plt-4.2.4-src-mac.dmg
16M	./4.2.4/plt/plt-4.2.4-src-unix.tgz
19M	./4.2.4/plt/plt-4.2.4-src-win.zip
8.2M	./4.2.5/mz/mz-4.2.5-bin-i386-linux-debian.sh
8.2M	./4.2.5/mz/mz-4.2.5-bin-i386-linux-f12.sh
8.2M	./4.2.5/mz/mz-4.2.5-bin-i386-linux-ubuntu-jaunty.sh
8.5M	./4.2.5/mz/mz-4.2.5-bin-i386-osx-mac.dmg
6.5M	./4.2.5/mz/mz-4.2.5-bin-i386-win32.exe
8.2M	./4.2.5/mz/mz-4.2.5-bin-ppc-darwin.sh
8.5M	./4.2.5/mz/mz-4.2.5-bin-ppc-osx-mac.dmg
8.3M	./4.2.5/mz/mz-4.2.5-bin-x86_64-linux-f7.sh
5.2M	./4.2.5/mz/mz-4.2.5-src-mac.dmg
5.1M	./4.2.5/mz/mz-4.2.5-src-unix.tgz
6.7M	./4.2.5/mz/mz-4.2.5-src-win.zip
42M	./4.2.5/plt/plt-4.2.5-bin-i386-linux-debian.sh
42M	./4.2.5/plt/plt-4.2.5-bin-i386-linux-f12.sh
42M	./4.2.5/plt/plt-4.2.5-bin-i386-linux-ubuntu-jaunty.sh
43M	./4.2.5/plt/plt-4.2.5-bin-i386-osx-mac.dmg
27M	./4.2.5/plt/plt-4.2.5-bin-i386-win32.exe
42M	./4.2.5/plt/plt-4.2.5-bin-ppc-darwin.sh
43M	./4.2.5/plt/plt-4.2.5-bin-ppc-osx-mac.dmg
43M	./4.2.5/plt/plt-4.2.5-bin-x86_64-linux-f7.sh
16M	./4.2.5/plt/plt-4.2.5-src-mac.dmg
16M	./4.2.5/plt/plt-4.2.5-src-unix.tgz
19M	./4.2.5/plt/plt-4.2.5-src-win.zip
7.1M	./4.2/mz/mz-4.2-bin-i386-linux-f9.sh
7.1M	./4.2/mz/mz-4.2-bin-i386-linux-ubuntu-hardy.sh
7.1M	./4.2/mz/mz-4.2-bin-i386-linux-ubuntu-jaunty.sh
7.3M	./4.2/mz/mz-4.2-bin-i386-osx-mac.dmg
5.9M	./4.2/mz/mz-4.2-bin-i386-win32.exe
7.1M	./4.2/mz/mz-4.2-bin-ppc-darwin.sh
7.3M	./4.2/mz/mz-4.2-bin-ppc-osx-mac.dmg
7.0M	./4.2/mz/mz-4.2-bin-sparc-solaris.sh
7.2M	./4.2/mz/mz-4.2-bin-x86_64-linux-f7.sh
4.7M	./4.2/mz/mz-4.2-src-mac.dmg
4.6M	./4.2/mz/mz-4.2-src-unix.tgz
6.0M	./4.2/mz/mz-4.2-src-win.zip
39M	./4.2/plt/plt-4.2-bin-i386-linux-f9.sh
39M	./4.2/plt/plt-4.2-bin-i386-linux-ubuntu-hardy.sh
39M	./4.2/plt/plt-4.2-bin-i386-linux-ubuntu-jaunty.sh
40M	./4.2/plt/plt-4.2-bin-i386-osx-mac.dmg
25M	./4.2/plt/plt-4.2-bin-i386-win32.exe
39M	./4.2/plt/plt-4.2-bin-ppc-darwin.sh
40M	./4.2/plt/plt-4.2-bin-ppc-osx-mac.dmg
39M	./4.2/plt/plt-4.2-bin-sparc-solaris.sh
39M	./4.2/plt/plt-4.2-bin-x86_64-linux-f7.sh
15M	./4.2/plt/plt-4.2-src-mac.dmg
15M	./4.2/plt/plt-4.2-src-unix.tgz
18M	./4.2/plt/plt-4.2-src-win.zip

|#

(define (bundle-platform-name bundle)
  (define name
    (case (bundle-platform bundle)
      ;; binary platforms
      [(i386-win32)        "Windows (95 and up) x86"]
      [(ppc-osx-mac)       "Macintosh OS X (PPC)"]
      [(i386-osx-mac)      "Macintosh OS X (Intel)"]
      [(ppc-darwin)  (concat "Macintosh Darwin"
                             (if (eq? 'mz (bundle-package bundle)) " X11" "")
                             " (PPC)")]
      [(i386-darwin) (concat "Macintosh Darwin"
                             (if (eq? 'mz (bundle-package bundle)) " X11" "")
                             " (Intel)")]
      [(ppc-mac-classic)   "Macintosh Classic ppc"]
      [(68k-mac-classic)   "Macintosh Classic 68k"]
      [(i386-linux)        "Linux (i386)"]
      [(i386-linux-gcc2)   "Linux (i386, older GCC2)"]
      [(i386-linux-fc2)    "Linux - Fedora Core 2 (i386)"]
      [(i386-linux-fc5)    "Linux - Fedora Core 5 (i386)"]
      [(i386-linux-fc6)    "Linux - Fedora Core 6 (i386)"]
      [(i386-linux-f7)     "Linux - Fedora 7 (i386)"]
      [(x86_64-linux-f7)   "Linux - Fedora 7 (x86_64)"]
      [(i386-linux-f9)     "Linux - Fedora 9 (i386)"]
      [(i386-linux-f12)    "Linux - Fedora 12 (i386)"]
      [(i386-linux-debian) "Linux - Debian Stable (i386)"]
      [(i386-linux-debian-testing)  "Linux - Debian Testing (i386)"]
      [(i386-linux-debian-unstable) "Linux - Debian Unstable (i386)"]
      [(i386-linux-ubuntu)          "Linux - Ubuntu (i386)"]
      [(i386-linux-ubuntu510)       "Linux - Ubuntu Breezy (i386)"]
      [(i386-linux-ubuntu-dapper)   "Linux - Ubuntu Dapper (i386)"]
      [(i386-linux-ubuntu-edgy)     "Linux - Ubuntu Edgy (i386)"]
      [(i386-linux-ubuntu-feisty)   "Linux - Ubuntu Feisty (i386)"]
      [(i386-linux-ubuntu-hardy)    "Linux - Ubuntu Hardy (i386)"]
      [(i386-linux-ubuntu-intrepid) "Linux - Ubuntu Intrepid (i386)"]
      [(i386-linux-ubuntu-jaunty)   "Linux - Ubuntu Jaunty (i386)"]
      [(i386-freebsd)      "FreeBSD i386"]
      [(sparc-solaris)     "Sparc Solaris (SunOS)"]
      [(i386-kernel)       "x86 Standalone Kernel"]
      [(i386-linux-rh)     "RedHat Linux i386"]
      ;; source platforms
      [(win) "Windows"]
      [(mac) "Macintosh"]
      [(unix) (concat "Unix"
                      (if (eq? 'plt (bundle-package bundle)) " (X11)" ""))]
      [(linux-rh) "RedHat Linux"]
      [(all)  "All Platforms"]
      [else (error 'bundle-platform-name
                   "unknown platform: ~e" (bundle-platform bundle))]))
  (if (eq? 'src (bundle-disttype bundle))
    (concat "Source code for " name)
    name))

(define (bundle-extension-name bundle)
  (case (bundle-extension bundle)
    [(tgz)      "Gunzipped TAR Archive"]
    [(zip)      "Zipped Archive"]
    [(src.rpm)  "Source RPM"]
    [(i386.rpm) "Binary RPM for i386"]
    [(sit)      "StuffIt Archive"]
    [(sit.bin)  "StuffIt Archive (Binary)"]
    [(dmg)      "Disk Image"]
    [(exe)      "Windows Installer"]
    [(sh)       "Self-extracting shell script"]
    [(plt)      "PLT Installation Package"]
    [else (error 'bundle-extension-name
                 "unknown extension: ~e" (bundle-extension bundle))]))

(define (bundle-installation-instructions bundle)
  ((case (bundle-extension bundle)
     [(plt) plt-instructions]
     [(exe) exe-instructions]
     [(zip) zip-instructions]
     [(sit sit.bin) sit-instructions]
     [(dmg) dmg-instructions]
     [(src.rpm i386.rpm) rpm-instructions]
     [(sh)  sh-instructions]
     [(tgz) tgz-instructions]
     [else (lambda (b)
             @'{There are no download instructions for this download.})])
   bundle))

(define (plt-instructions bundle)
  ;; this is also used by patches/index.ss -- with a void argument (it's not
  ;; used anyway)
  @splice{
    @p{This is a PLT package file.  To install it, you need to run the PLT
       setup utility:
       @dl{@dt{@b{Windows}}
           @dd{Either open the file when you download it, or double click the
               downloaded file to install it.  You can also drag it onto the
               @code{Setup PLT} executable in the PLT directory.}
           @dt{@b{Macintosh}}
           @dd{Drag the file onto the @code{Setup PLT} application in the PLT
               folder.}
           @dt{@b{Unix}}
           @dd{In a shell, run @code{plt/bin/setup-plt} with the downloaded
               file as an argument.}}
       Most PLT packages will get written to a user-specific directory, but
       some will try to create files in the PLT installation directory
       @mdash in this case you will have to do this with the appropriate
       administrative rights (if the PLT directory is in a system location).}
    @p{@b{System administrators:} if you want to install a PLT package for all
       users of a system, use the @code{--all-users} flag on the command line
       when you do the above procedure (you should use the command-line to do
       the installation).}})

(define (exe-instructions bundle)
  @splice{
    This is a Windows installer program.  Simply run it, and an installation
    wizard will guide you through the installation process. @br{}
    @b{Note:} If you have a previously installed version of
    @(bundle-name bundle), uninstall it before using this installer.
    @(if (version<=? (bundle-version bundle) "205")
       @p{The installer creates a file called @code{install.log} and installs a
          program called @code{Uninstall.exe}.  The uninstaller must read
          @code{install.log} to uninstall the distribution (so don't delete
          it).}
       "")})

(define (zip-instructions bundle)
  @splice{
    This is a zipped archive that contains the PLT tree.  Unzip the file to a
    suitable location.
    @(if (memq (bundle-platform bundle) '(win i386-win32))
       @splice{Remember to use directory names when extracting the contents of
               this archive (eg, with WinZip, make sure that "Use folder names"
               is checked).}
       @splice{})
    @(if (eq? 'bin (bundle-disttype bundle))
       @splice{The @(bundle-name bundle) executable is located in the PLT
               directory.}
       @splice{})})

(define (sit-instructions bundle) ; only for old distributions
  @splice{
    Use Unstuffit or Stuffit Expander to unpack the archive file.  The
    distribution will be unpacked to a new PLT folder.  In this folder, double
    click the Setup PLT application to finish the installation.  At this point,
    the @(bundle-name bundle) can be run by double-clicking its icon.})

(define (dmg-instructions bundle)
  (define download-instructions
    @splice{
       Download the file, and double-click it in the Finder to mount the disk
       image.  Finder will start the Disk Copy utility to mount the image.
       @br{}
       Once this is done, double-click the mounted image on the desktop to open
       its window Finder window (if it was not opened automatically).})
  (cond
    [(version<? (bundle-version bundle) "203") ; pre-203
     @splice{
       @download-instructions
       In this folder you will find a package icon (an mpkg file) @mdash
       double click it to install the software.  Finder will start the
       Installer utility to perform the installation.
       @br{}
       The installation will place the @(bundle-name bundle) files in
       @code{@(if (eq? 'mz (bundle-package bundle))
                "/sw/local/plt" "/Applications/PLT")} and support frameworks in
       @code{/Library/Frameworks}.}]
    [(version<? (bundle-version bundle) "206") ; pre-206
     @splice{
       @download-instructions
       In this folder you will find a package icon (an mpkg file) and a PLT
       folder.  First, double click the package to install the required
       frameworks.  Then, drag the PLT folder to your disk, wherever you want
       it to go (The @code{Applications} folder is the traditional choice).
       After you have coped the folder, open the new copy, and double-click
       @(if (eq? 'mz (bundle-package bundle))
          @splice{@code{finish install.command}}
          @splice{the @code{Finish Install} program}).}]
    [(and (eq? 'bin (bundle-disttype bundle))
          (version<=? (bundle-version bundle) "301")) ; old pkg-dmg
     @splice{
       Once you finish downloading the disk image file, the Finder should
       automatically mount it, copy its contents to your desktop, and run the
       contained Installer package.  If this was not done in your case then you
       will have to do it manually (the image contains only a single package
       icon). @br{}
       Installer will not allow you to choose a destination, it will install
       the required support frameworks in @code{/Library/Frameworks}@;
       @(if (eq? 'libs (bundle-package bundle))
          @splice{.}
          @splice{ and the PLT folder in @code{/Applications/PLT Scheme vNNN}.
             @br{}
             Finally, if you want to have the PLT tree at a different place,
             then move it to the new location and immediately open it and
             double click @(if (eq? 'mz (bundle-package bundle))
                             @splice{@code{finish install.command}}
                             @splice{the @code{Finish Install} program}).
             This might fail if you don't have the permissions @mdash in this
             case you will need to use some tool to run this as the
             administrator (one such tool is "Pseudo").  Otherwise you will
             need to use command-line tools like @code{sudo}.  Note that
             @code{sudo} will not work with @code{open}, because that will just
             talk with the running Finder, you can run it directly with
             @(if (eq? 'mz (bundle-package bundle))
                @code{sudo "./finish install.command"}
                @code{sudo ./install -i})})}]
    [(eq? 'bin (bundle-disttype bundle)) ; bin-dmg
     @splice{
       Once you finish downloading the disk image file, some browsers will
       automatically mount it and copy the PLT Scheme folder to your desktop.
       Simply drag this folder to a convenient place in your system.
       If your browser doesn't mount and copy it automatically, you will need
       to do so yourself.}]
    [(eq? 'src (bundle-disttype bundle)) ; src-dmg
     @splice{
       This is a disk image file that contains a PLT folder which includes the
       @code{src} subtree.}]
    [else (error 'dmg-instructions "bad disttype: ~e" (bundle-file bundle))]))

(define (rpm-instructions bundle)
  @splice{
    This is a RedHat RPM file.  It should be installed in a standard way, for
    example, by using @code{rpm -i} on a command-line.  Use @code{man rpm} for
    more information.})

(define (sh-instructions bundle)
  (define file.sh (bundle-file bundle))
  @splice{
    This is a self-installing shell script.  Use the following instructions to
    run the script: @br{}
    @code{> chmod +x @(bundle-file bundle)} @br{}
    @code{> sh @(bundle-file bundle)} @br{}
    The installer will verify its integrity, then ask you where you want to
    install the PLT tree.  Optionally, it can create some links in standard
    directories like links in the system's @tt{bin}, @tt{lib}, and @tt{man}
    directories (it will ask for your permission first).  @br{}
    @b{Note:}
    @(case (bundle-platform bundle)
       [(i386-linux)
        @splice{
          These binaries were compiled on a Fedora Core 2 distributions.  If
          you get libc-related errors then you should try other linux builds,
          or compile from source.}]
      [(i386-linux-gcc2)
        @splice{
          These binaries were compiled on an older Linux configuration, which
          are intended for installation on such systems like RedHat 7.3.}]
       [(i386-linux-fc2)
        @splice{
          These binaries were compiled on a Fedora Core 2 distribution.}]
       [(i386-linux-fc5)
        @splice{
          These binaries were compiled on a Fedora Core 5 distribution.}]
       [(i386-linux-fc6)
        @splice{
          These binaries were compiled on a Fedora Core 6 distribution.}]
       [(i386-linux-f7)
        @splice{
          These binaries were compiled on a Fedora 7 distribution.}]
       [(x86_64-linux-f7)
        @splice{
          These binaries were compiled on a Fedora 7 distribution (x86_64).}]
       [(i386-linux-f9)
        @splice{
          These binaries were compiled on a Fedora 9 distribution.}]
       [(i386-linux-f12)
        @splice{
          These binaries were compiled on a Fedora 12 distribution.}]
       [(i386-linux-debian)
        @splice{
          These binaries were compiled on a Debian stable configuration.}]
       [(i386-linux-debian-testing)
        @splice{
          These binaries were compiled on a Debian testing configuration.}]
       [(i386-linux-debian-unstable)
        @splice{
          These binaries were compiled on a Debian unstable configuration.}]
       [(i386-linux-ubuntu)
        @splice{These binaries were compiled on Ubuntu Linux.}]
       [(i386-linux-ubuntu510)
        @splice{These binaries were compiled on Ubuntu Linux (Breezy).}]
       [(i386-linux-ubuntu-dapper)
        @splice{These binaries were compiled on Ubuntu Linux (Dapper).}]
       [(i386-linux-ubuntu-edgy)
        @splice{These binaries were compiled on Ubuntu Linux (Edgy).}]
       [(i386-linux-ubuntu-feisty)
        @splice{These binaries were compiled on Ubuntu Linux (Feisty).}]
       [(i386-linux-ubuntu-hardy)
        @splice{These binaries were compiled on Ubuntu Linux (Hardy).}]
       [(i386-linux-ubuntu-intrepid)
        @splice{These binaries were compiled on Ubuntu Linux (Intrepid).}]
       [(i386-linux-ubuntu-jaunty)
        @splice{These binaries were compiled on Ubuntu Linux (Jaunty).}]
       [(i386-freebsd)
        @splice{These binaries were compiled on an Intel FreeBSD platform.}]
       [(ppc-darwin)
        @splice{
          These binaries were compiled with Mac OSX on Darwin@;
          @(if (eq? 'plt (bundle-package bundle)) "(using X11)" "")
          on a PPC machine.}]
       [(i386-darwin)
        @splice{
          These binaries were compiled with Mac OSX on Darwin@;
          @(if (eq? 'plt (bundle-package bundle)) "(using X11)" "")
          on an Intel machine.}]
       [(sparc-solaris)
        @splice{
          These binaries were compiled on a fairly maintained Sparc machine.
          You might need to adjust @tt{LD_LIBRARY_PATH} to point to a
          directory where you have GCC runtime-libraries.  You might also need
          to adjust limits, in particular datasize and stacksize (eg,
          @tt{ulimit -s unlimited@";" ulimit -d unlimited})}]
       [else (error 'sh-instructions "bad platform (~e) for: ~e"
                    (bundle-platform bundle) file.sh)])})

(define (tgz-instructions bundle)
  (define file.tgz (bundle-file bundle))
  (define file.tar (regexp-replace #rx"\\.t(?:ar.)?gz$" file.tgz ".tar"))
  @splice{
    @p{This is a gzipped TAR archive.  If you use recent GNU @tt{tar}, then you
       can unpack it with a single @code{tar xvzf @file.tgz} command.
       Otherwise you need to gunzip the file first using
       @code{gunzip @file.tgz}, then unpack the resulting file with
       @code{tar xvf @file.tar}.}
    @(cond [(eq? 'i386-kernel (bundle-platform bundle))
            @p{See the @tt{README} file contained in the downloaded archive for
               additional details.}]
           [(eq? 'bin (bundle-disttype bundle))
            @p{After unpacking, you can move the PLT directory to wherever you
               want it installed in your disk, then @tt{cd} into that directory
               and run the installation script with @code{./install}.  PLT
               executables are all in the @tt{bin} subdirectory in the PLT tree
               @mdash you may want to create links in a directory that is
               included in your @tt{PATH}, or make your @tt{PATH} include this
               directory.}]
            [else ""])})

;; ============================================================================
;; code

;; version: like the version collection, but handle old version numbers
(require (prefix-in v: version/utils))
(define ver->int
  (let ([t (make-hash)])
    (lambda (v)
      (let ([v ;; deal with "053", for example
             (regexp-replace #rx"^0+([0-9])" v "\\1")])
        (hash-ref t v
          (lambda ()
            (let ([i (if (equal? "" v) 0 (v:version->integer v))])
              (hash-set! t v i) i)))))))
(define (version<? v1 v2)
  (< (ver->int v1) (ver->int v2)))
(define (version<=? v1 v2)
  (or (equal? v1 v2) (<= (ver->int v1) (ver->int v2))))
;; got rid of all older alpha versions
(define (alpha-version? v) (and (v:valid-version? v) (v:alpha-version? v)))

(define-struct bundle
  ([name #:mutable]
   package version disttype platform extension path file file.html size))

(define-match-expander rx
  (syntax-rules ()
    [(rx regexp x ...)
     (app (lambda (str) (regexp-match regexp str)) (list _ x ...))]))

(define (string->bundle str)
  (define (check-symbol-in name x xs)
    (let ([x (string->symbol x)])
      (if (member x xs)
        x (error 'bundle-information "unknown ~a: ~e not in ~e" name x xs))))
  (match str
    [(rx #rx"^([0-9][0-9.]+[KM])[ \t]+\\./(([^/]+)/([^/]+)/([^/]+))$"
              size                        path     ;       ;
                                           version package file)
     (match file
       [(rx (concat "^"package"-"version"-([^-./]+)-([^./]+)\\.([^-/]+)$")
                                          disttype  platform   extension)
        (writing (concat bundles-base-url/ path))
        (and (not (memq (string->symbol package) ignored-packages))
             (make-bundle #f ; filled later, when a download page is made
                          (check-symbol-in 'package package packages)
                          version
                          (check-symbol-in 'disttype disttype disttypes)
                          (check-symbol-in 'platform platform platforms)
                          (check-symbol-in 'extension extension extensions)
                          path
                          file
                          (concat (regexp-replace* #rx"\\." file "-") ".html")
                          (concat size "b")))]
       [_ (error 'string->bundle "bad bundle filename: ~e" file)])]
    [_ (error 'string->bundle "bad bundle line: ~e" str)]))

(define all-bundles
  (let* ([make<?
          (lambda (order p)
            (lambda (x y)
              (and (not (equal? (p x) (p y)))
                   (if (member (p y) (cdr (member (p x) order))) '< '>))))]
         [version*<?
          (lambda (x y)
            (and (not (equal? (bundle-version x) (bundle-version y)))
                 (if (version<? (bundle-version x) (bundle-version y))
                   '< '>)))]
         [package<?  (make<? packages  bundle-package)]
         [disttype<? (make<? disttypes bundle-disttype)]
         [platform<? (make<? platforms bundle-platform)]
         [bundle<?
          (lambda (x y)
            (eq? '< (or (package<? x y)
                        (version*<? x y)
                        (disttype<? x y)
                        (platform<? x y)
                        (error 'bundle-information
                               "two entries for the same configuration: ~e ~e"
                               x y))))])
    (with-input-from-file (build-path (this-expression-source-directory)
                                      (this-expression-file-name))
      (lambda ()
        (let loop ([r '()])
          (let ([l (read-line)])
            (cond
             [(eof-object? l) (sort (reverse r) bundle<?)]
             [(regexp-match-positions #rx"^[0-9][0-9.]*[KM][ \t]+\\./" l)
              => (lambda (m)
                   (let ([b (string->bundle l)])
                     (loop (if b (cons b r) r))))]
             [else (loop r)])))))))

(add-exit-hook
 (lambda ()
   (for ([b all-bundles])
     (unless (bundle-name b)
       (warn "bundle page not created for: ~a" (bundle-path b))))))

;; the two versions are equal when the current release is not an alpha
;; `all-versions' is sorted from oldest to newest
(define-values (plt-version plt-stable-version all-versions)
  (let loop ([bs all-bundles] [max ""] [stable ""] [vs '()])
    (if (null? bs)
      (values max stable (sort vs version<?))
      (let ([v (bundle-version (car bs))])
        (loop (cdr bs)
              (if (version<? max v) v max)
              (if (and (not (alpha-version? v)) (version<? stable v)) v stable)
              (if (member v vs) vs (cons v vs)))))))

(define (tag->version tag . stable?)
  ;; if stable? is true, then find the most recent *integer* version,
  ;; otherwise, return the most recenet version.
  (let ([stable? (and (pair? stable?) (car stable?))])
    (let loop ([bs all-bundles] [max #f])
      (if (null? bs)
        max
        (loop (cdr bs)
              (if (and (eq? tag (bundle-package (car bs)))
                       (not (and stable?
                                 (alpha-version? (bundle-version (car bs)))))
                       (or (not max)
                           (version<? max (bundle-version (car bs)))))
                (bundle-version (car bs))
                max))))))

(define (split-bundles-by-version bundles)
  (let loop ([bs bundles] [table '()])
    (cond
     [(null? bs)
      (reverse (map (lambda (x) (cons (car x) (reverse (cdr x)))) table))]
     [(assoc (bundle-version (car bs)) table)
      => (lambda (l)
           ;; func. version below (set-cdr! l (cons (car bs) (cdr l)))
           (loop (cdr bs)
                 (let loop ([table table])
                   (if (eq? l (car table))
                     (cons (cons (caar table)
                                 (cons (car bs) (cdar table)))
                           (cdr table))
                     (cons (car table) (loop (cdr table)))))))]
     [else (loop (cdr bs) (cons (list (bundle-version (car bs)) (car bs))
                                table))])))

(define (bundle->download-page title bundle)
  (define (row label text)
    @tr{@td[align: 'right]{@b{@label}:}
        @td{@nbsp}
        @td[align: 'left]{@text}})
  @text{
    @warning:old-installers
    @table[width: "90%" align: 'center]{
      @tr[valign: 'top]{
        @td[width: "50%"]{
          @table{@(row "Package"  title)
                 @(row "Version"  (bundle-version bundle))
                 @(row "Platform" (bundle-platform-name bundle))
                 @(row "Type"     (bundle-extension-name bundle))
                 @(row "File"     (bundle-file bundle))
                 @(row "Size"     (bundle-size bundle))}}
        @td[width: "50%"]{
          @p{Download links:
             @|nbsp nbsp nbsp| (Choose the nearest site)
             @ul{@(apply splice
                         (map (lambda (m)
                                (let* ([name (car m)]
                                       [name (if (list? name)
                                               (apply splice name)
                                               (splice name))]
                                       [href (concat (cadr m)
                                                     (bundle-path bundle))]
                                       [href (if (regexp-match #rx"^/" href)
                                               (url href) href)])
                                  @li{@a[href: href]{@name}}))
                              mirrors))}}}}}
    @section{Installation instructions}
    @(bundle-installation-instructions bundle)
    @br{}
    @div[align: 'right]{(@(link-to 'license))}})

(define platform-script
  @script[type: 'text/javascript]{@literal{@||
    (function() {
    var opts = document.getElementById("xURL").options;
    var len = opts.length;
    // returns a platform name, doubles as a regexp too
    function getPlatform() {
      var p = navigator.platform;
      var l = function(str) { return p.indexOf(str) != -1@";" }
      // The default is the common case
      return (p == null)  ? "Windows" :
             l("Linux") ? (l("_64") ? "Linux x86_64" : "Linux i386")   :
             l("SunOS") ? "Solaris" :
             l("Mac") ? (l("Intel") ? "Mac OS X Intel" : "Mac OS X PPC") :
             "Windows";
    }
    // convert name to a regexp by splitting on words
    var rx = new RegExp(getPlatform().replace(/ +/g,".*"));
    for (var i=0@";" i<len@";" i++) {
      if (opts[i].text.search(rx) >= 0) {
        opts.selectedIndex = i; break;
      }
    }
    })();
    @||}})

(define (make-options button-label urls labels)
  (let ([on-click
         ;; This doesn't work with Netscape 4.7x:
         ;; "window.location = document.forms.PLT.xURL.value; return false"
         (concat "window.location ="
                 " this.form.xURL.options[this.form.xURL.selectedIndex].value;"
                 " return false;")])
    (splice
     @nobr{
       @select[name: "xURL" id: "xURL"]{
         @(apply splice
                 (map (lambda (u l) @option[value: (url u)]{@l})
                      urls labels))}@;
       @|nbsp|@;
       @input[type: 'submit onclick: on-click value: button-label]}
     platform-script)))

(import-from "patches/" patched-versions)

(define (make-download-form version other-versions options)
  ;; version = #f => this is the all-versions page
  @form[name: 'PLT method: 'post action: (url "/cgi-bin/redirect")]{
    @warning:old-installers
    @table[align: 'center width: "95%" border: 0 cellpadding: 4]{
      @tr{@td[align: 'right]{@b{Version:}}
          @td[align: 'left]{
            @(if version
               @nobr{@b{@version}
                 @(if (alpha-version? version)
                    @small{@font[color: 'red]{@|nbsp|ALPHA}}
                    "")}
               options)}
          @td[align: 'right]{@nobr{@(apply splice other-versions)}}}
      @tr[height: 6]{@td[colspan: 3]{@""}}
      @(if version
         @tr{@td[align: 'right]{@b{Platform:}}
             @td[align: 'left colspan: 2]{@options}}
         @tr{@td[colspan: 3]{@nbsp}})
      @tr{@td[colspan: 3 align: 'center]{
          @(cond [(assoc version (force patched-versions))
                  => (lambda (ver+link) (cadr ver+link))]
                 [else nbsp])}}}})

(define (version->page other-versions version . bundles)
  (make-download-form version other-versions
                      (make-options "Download"
                                    (map bundle-file.html bundles)
                                    (map bundle-platform-name bundles))))

(define (all-versions-page version-bundles recent-version stable-version)
  (let* ([versions (reverse (map car version-bundles))]
         [htmls  (map (lambda (v) (concat "v" v ".html")) versions)]
         [labels (map (lambda (v)
                        (concat
                         "v" v
                         (cond [(equal? v plt-version)    " (current)"]
                               [(equal? v recent-version) " (recent)"]
                               [(equal? v stable-version) " (stable)"]
                               [(equal? v (car versions)) " (recent)"]
                               [else ""])))
                      versions)])
    (make-download-form #f '(nbsp) (make-options "Go" htmls labels))))

(define (make-package-pages tag name make-panel make-tall make-raw)
  (define bundles
    (filter (lambda (b) (eq? tag (bundle-package b))) all-bundles))
  (define (max-version smaller?)
    (foldl (lambda (b m)
             (let ([bv (bundle-version b)]) (if (smaller? m bv) bv m)))
           "" bundles))
  (define recent-version (max-version version<?))
  (define stable-version
    (max-version (lambda (x y) (and (version<? x y) (not (alpha-version? y))))))
  ;; set the bundle names, this is also used to mark that they were scanned
  (for ([b bundles]) (set-bundle-name! b name))
  (for ([b bundles])
    (make-tall (bundle-file.html b)
               (concat "Download " name " v" (bundle-version b))
               (bundle->download-page name b)))
  (let* ([version-bundles (split-bundles-by-version bundles)]
         [version-num (length version-bundles)])
    (for ([version+bundles version-bundles])
      (let* ([recent? (equal? recent-version (car version+bundles))]
             [other-versions
              (if (<= version-num 1)
                '(nbsp)
                (let ([other @small{@a[href: (url "all-versions.html")]{
                                      Other Versions}}])
                  (if (and recent?
                           (not (equal? recent-version stable-version)))
                    (list @small{@a[href: (url (concat "v" stable-version
                                                       ".html"))]{
                                   Version @stable-version (stable)}}
                          `(br ())
                          other)
                    (list other))))])
        (when recent?
          (let ([contents (apply version->page other-versions version+bundles)])
            (define (not-current)
              @text{
                @br{}@hr{}
                @small{@b{Note:} this package has no available version for
                       the current PLT Scheme version (@plt-version).}})
            (make-panel "index.html"
                        (if (equal? recent-version plt-version)
                          contents
                          ;; note: adds `no-current' into the form
                          (append contents (not-current))))))
        (make-panel (concat "v" (car version+bundles) ".html")
                    (apply version->page other-versions version+bundles))))
    (make-panel "all-versions.html"
                (all-versions-page version-bundles
                                   recent-version stable-version))))

;; Creates the download pages and returns a download link for the main one
(define (make-download-pages tag name sys-req title
                             [output-dir (basename (current-web-dir))])
  (define output-dir/ (concat output-dir "/"))
  (define panel-footer
    @text{
      @br{}
      @hr{}
      @div[align: 'center]{
        @small{@(link-to 'license)
               @|nbsp bull nbsp|
               @(link-to 'pre-release-installers)}}
      @hr{}
      @sys-req})
  ;; This will get a panel to use for the content, but the panel needs the link
  ;; that we create -- so return a function that can return the link with no
  ;; arguments (panel page will use it) and it can also create the content
  ;; page.  Also, since it will be used in a different build context, use
  ;; `with-this-context' to work in the proper place.
  (define (handler . msg+args)
    (with-this-context
      (define path (absolute-path output-dir/))
      (define url* (url path))
      (define link @a[href: url*]{@title})
      (define path+title (list path title))
      (define (run panel)
        (with-converted-dir path
          (lambda ()
            (make-package-pages tag name
              (lambda (file contents)
                (apply write-panel-page* #:fake-url url* #:navkey 'download
                       file panel title
                       @br{} contents panel-footer))
              (lambda (file title contents)
                (apply write-tall-page* file title #:navkey 'download contents))
              (lambda (file contents) (write-raw* file contents))))))
      (if (null? msg+args)
        (handler 'path+title)
        (let ([handler (case (car msg+args)
                         [(url) url*] [(link) link] [(path+title) path+title]
                         [(run) run]
                         [else (error 'download-panel
                                      "bad message: ~e" (car msg+args))])])
          (if (and (null? (cdr msg+args)) (not (procedure? handler)))
            handler
            (apply handler (cdr msg+args)))))))
  handler)
