#lang scheme/base

(provide (all-defined-out))

(require "../../common/paths.ss" "../../common/conf.ss" "../../common/utils.ss"
         "conf.ss" scheme/system xml)

(define image-dir (simplify-path (build-path source-dir screenshots-dir)))

(define info-file            (build-path image-dir "screenshots.ss"))
(define image-info           (dynamic-require info-file 'info))
(define initial-image        (dynamic-require info-file 'initial))
(define initial-image-source (build-path image-dir initial-image))

(define-struct image (num file thumb title blurb source-path))

(define images
  (let ([c (let ([c -1]) (lambda () (set! c (add1 c)) c))])
    (map (lambda (i)
           (let ([file (car i)] [title (cadr i)] [blurb (caddr i)])
             (make-image (c)
                         (path->string (path-replace-suffix file ".jpg"))
                         (regexp-replace #rx"[.][^.]+$" file "-thumb.png")
                         title
                         (if (pair? blurb)
                           (if (symbol? (car blurb))
                             (xexpr->string blurb)
                             (apply concat (map xexpr->string blurb)))
                           blurb)
                         (build-path image-dir file))))
         image-info)))

(define (height->size h)
  (format "~ax~a" (height->width h) h))

(define (render-image src dst thumb?)
  ;; (when (file-exists? dst) (delete-file dst))
  (unless (file-exists? dst)
    (eprintf "...creating ~a\n" dst)
    (let* ([size (height->size (if thumb?
                                 (* thumb-height (- 1 thumb-pad))
                                 image-height))]
           [size> (format "\"~a>\"" size)]
           [size  (format "\"~a\"" size)]
           [s (concat "composite"
                      " -gravity center"
                      ;; <1 sharpen, >1 blur (no effect on Box?)
                      " -support "(if thumb? "0.5" "1.0")
                      ;; " -filter "(if thumb? "Box" "Blackman") ; or Lanczos
                      " "(if thumb? "-thumbnail" "-resize")" "size>
                      (if thumb? " -colors 256" "")
                      (format " ~s" src)
                      " -geometry "size>
                      " -size "size
                      " XC:\"#"(if thumb? "C0C0C0" "FFFFFF")"\""
                      (format
                       (if thumb?
                         (concat " miff:-"
                                 " | convert"
                                 " -bordercolor \"#202080\""
                                 " -border 2x2"
                                 " -raise 2x2"
                                 " miff:- miff:-"
                                 " | composite -gravity center miff:-"
                                 " -size "(height->size thumb-height)
                                 " -quality 90"
                                 " XC:transparent"
                                 " ~s")
                         (concat " -quality 90"
                                 " ~s"))
                       dst))])
      ;; (eprintf "Running ~a\n" s)
      (system s))))

(define (render-images+thumbs)
  (render-image (path->string initial-image-source) initial-image #f)
  (for ([image images])
    (let ([src (path->string (image-source-path image))])
      (render-image src (image-file  image) #f)
      (render-image src (image-thumb image) #t)))
  (system "convert -size 1x1 XC:transparent \"blank.png\"")
  (system (format "convert -size 1x1 XC:\"#~a\" \"bg.png\"" bubble-bcolor)))
