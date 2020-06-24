#lang scheme/base

(require "utils.ss" "conf.ss" "paths.ss" "distribute.ss"
         scheme/path scheme/cmdline)

(define* distributing? (make-parameter #f)) ; copy stuff over?
(define* testing?      (make-parameter #f)) ; is this a temporary build?

(define only-dirs #f) ; in case we want to build a few top-dirs only

(define (do-file /path)
  (eprintf "~a: " /path)
  (with-converted-dir /path
    (lambda ()
      ((if (regexp-match ".[.]ss$" /path) run-file install-file)
       (concat source-dir /path)))))

(define (do-dir /dir)
  ;; (eprintf "~a\n" /dir)
  (for ([p (dir (concat source-dir /dir))])
    (let* ([sub (concat /dir "/" p)]
           [src (concat source-dir sub)])
      (cond [(directory-exists? src) (do-dir sub)]
            [(file-exists? src) (do-file sub)]
            [else (error 'build "internal error (~e)" src)]))))

(define (do-top-dir dir)
  (let* ([/dir (concat "/" dir)]
         [ex? (directory-exists? (concat source-dir /dir))])
    (eprintf "==================== ~a ~a -> ~a\n"
             (if ex? "Making" ">>> Skipping nonexistent") dir (url /dir #t))
    (when ex? (do-dir /dir))))

(define (do-top-dirs)
  (for-each do-top-dir (or only-dirs top-dirs)))

(define* (build)
  (build-dir (current-directory))
  ;; this can be used for common/blah things for modules, but it requires
  ;; setting PLTCOLLECTS if not going through the build script.
  ;; (current-library-collection-paths
  ;;  (cons source-dir (current-library-collection-paths)))
  (when (equal? (normalize-path source-dir) (normalize-path (build-dir)))
    (error 'build "cannot run this script from its source directory"))
  (command-line
   #:once-each
   ["--dist" "distribute resulting content"
             "  (will only work with the right access to the servers)"
    (distributing? #t)]
   ["--root" root "http://xxx.plt-home.org/ => <root>xxx/"
    (distributing? #f) (testing? #t)
    (set-simple-mappings! root)]
   ["--here" "build here, using `file://' URLs"
    (distributing? #f) (testing? #t)
    (set-simple-mappings! (concat "file://" (current-directory)))]
   #:multi
   ["--only" dir "build only this top-level directory (experimental)"
                 "  (can be used several times for more than one)"
    (if (member dir top-dirs)
      (set! only-dirs (append (or only-dirs '()) (list dir)))
      (error 'build "given directory is not top-level: ~e" dir))])
  (when (and (distributing?) only-dirs)
    (error 'build "cannot distribute a partial build"))
  (do-top-dirs)
  (eprintf "==================== Done\n")
  (unless only-dirs
    (run-exit-hooks)
    (when (warnings?) (error 'build "warnings detected!"))))

(define* (distribute-all)
  (when (distributing?)
    (eprintf "==================== Distributing\n")
    (distribute top-dirs)
    (eprintf "==================== Done\n")))
