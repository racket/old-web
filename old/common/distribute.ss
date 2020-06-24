#lang scheme/base

(require "conf.ss" "utils.ss" scheme/system scheme/list)

(define (run fmt . args)
  (unless (system (apply format fmt args))
    (error 'distribute "errors when running: ~a" (apply format fmt args))))

(define (move from to)
  (unless (equal? from to) (rename-file-or-directory from to)))

(define* (distribute packages)
  (let ([distributions
         (map (lambda (dist)
                (list (car dist)
                      (map (lambda (d) (regexp-replace #rx":.*$" d ""))
                           (cdr dist))
                      (map (lambda (d) (regexp-replace #rx"^.*:" d ""))
                           (cdr dist))))
              distributions)])
    (unless (equal? (remove-duplicates (sort packages string<?))
                    (remove-duplicates (sort (mappend cadr distributions)
                                             string<?)))
      (error 'distribute "some top-level packages are not handled"))
    (for ([d distributions] #:when (car d))
     (let-values ([(host dir)
                   (apply values (cdr (regexp-match #rx"^([^:]+):(.*)$"
                                                    (car d))))])
       (eprintf "installing ~s to ~s\n" (cadr d) (car d))
       (for-each move (cadr d) (caddr d))
       (run "tar czf - ~a | ssh ~s install-tgz ~s"
            (apply concat (map (lambda (x) (format " ~s" x)) (caddr d)))
            host dir)
       (for-each move (caddr d) (cadr d))))))
