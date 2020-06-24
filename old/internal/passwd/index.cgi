#!/bin/sh
#| -*- scheme -*-
export PATH="$PATH:/usr/local/bin"
if [ -x "$PLTHOME/bin/mzscheme" ]; then
  exec "$PLTHOME/bin/mzscheme" -qr "$0" "$@"
elif [ -x "/usr/local/plt/bin/mzscheme" ]; then
  exec "/usr/local/plt/bin/mzscheme" -qr "$0" "$@"
else
  exec "mzscheme" -qr "$0" "$@"
fi
|#

(require (lib "cgi.ss" "net") (lib "xml.ss" "xml") (lib "sendmail.ss" "net")
         (lib "kw.ss") (lib "etc.ss"))

(define admin-email    "eli@barzilay.org")
(define domain         "plt-scheme.org")
(define htdigest-realm "Subversion")

(output-http-headers) ; no need to worry about this in errors

(define (write-page/exit title . body)
  (define icon "http://plt-scheme.org/plticon.ico")
  (write-xml/content
   (xexpr->xml
    `(html ()
       (head ()
         (link ([rel "icon"] [href ,icon] [type "image/ico"]))
         (link ([rel "shortcut icon"] [href ,icon]))
         (title ,title))
       (body ([bgcolor "white"]) (h1 () ,title) ,@body))))
  (exit 0))

(define error-style
  "background-color=\"red\"; color=\"yellow\"; font-weight=\"bold\"")

(define (error-exit fmt . args)
  (write-page/exit "Error"
    `(pre () (span ([style ,error-style]) ,(apply format fmt args)))))
(let ([handler
       (lambda (e) (error-exit "~a\n" (if (exn? e) (exn-message e) e)))])
  (if (namespace-variable-value 'uncaught-exception-handler #t (lambda () #f))
    (uncaught-exception-handler handler)
    (begin (current-exception-handler handler)
           (initial-exception-handler handler))))

(define field
  (let ([bindings
         ;; Hack: make it possible to hand of URLs that have a "?user:secret"
         ;; suffix with some identifying secret
         (let* ([qs (getenv "QUERY_STRING")]
                [qs (and qs (regexp-match #rx"^(.*?):(.*)$" qs))])
           (if qs
             `([username . ,(cadr qs)] [secret . ,(caddr qs)])
             (get-bindings)))])
    (lambda (key . default)
      ;; seems that key can be either a string or a symbol
      (let ([values (extract-bindings key bindings)])
        (cond [(null? values) #f]
              [(null? (cdr values)) (car values)]
              [else (error 'field
                           "multiple values for ~s: ~s" key values)])))))

(define username (field 'username))
(define passwd1  (field 'passwd1))
(define passwd2  (field 'passwd2))
(define comment  (field 'comment))
(define secret   (field 'secret))

(define/kw (show-input-screen #:optional message)
  (write-page/exit "PLT Passwords"
    `(p ()
       "This utility will create new hash lines that are required for"
       " accessing miscellaneous PLT resources.  Enter your password twice"
       ,(if secret "" ", and an optional comment to the administrator")
       "."
       "  The new hashes will be"
       " generated and sent to the administrator to put in the appropriate"
       " places.  Note that the change does not happen automatically.  Also,"
       " you should be accessing this page through " (tt () "https") ", so the"
       " process is secure.")
    `(form ([action "."] [method "post"])
       ,@(if secret
           `((input ([name "secret"] [value ,secret] [type "hidden"])))
           `())
       (table ([align "center"])
         (tr () (td ([align "right"]) "Username:" nbsp)
                (td () (input ([name "username"]
                               ,@(if username `([value ,username]) `())))))
         (tr () (td ([align "right"]) "Password:" nbsp)
                (td () (input ([name "passwd1"] [type "password"]))))
         (tr () (td ([align "right"]) "Again:" nbsp)
                (td () (input ([name "passwd2"] [type "password"]))))
         ,@(if secret
             `()
             `((tr () (td ([align "right"]) "Comment:" nbsp)
                      (td () (input ([name "comment"]
                                     ,@(if comment
                                         `([value ,comment]) `())))))))
         (tr () (td () nbsp)
                (td ([align "right"])
                  (input ([type "submit"] [value "Go!"]))))
         ,@(if message
             `((tr () (td ([align "center"] [colspan "2"])
                        (span ([style ,error-style]) ,message))))
             `())))))

;; No spaces in Python code!
(define htdigest-wrapper "
import sys, pexpect, tempfile;
(_,user,relm,pswd) = sys.argv; tmpf = tempfile.NamedTemporaryFile();
p = pexpect.spawn('htdigest', ['-c', tmpf.name, relm, user]);
p.expect('New password: '); p.sendline(pswd);
p.expect('Re-type new password: '); p.sendline(pswd);
p.expect(pexpect.EOF);
print tmpf.readline(),;
")

(define (show-passwd-lines)
  (define (run-passwd cmd . args)
    (let-values ([(p pout _pin _perr)
                  (apply subprocess
                         #f (current-input-port) (current-error-port)
                         (find-executable-path cmd) args)])
      (let loop ([r #f])
        (let ([line (read-line pout)])
          (cond [(eof-object? line)
                 (subprocess-wait p)
                 (or r (error-exit "~a did not produce any output" cmd))]
                [(equal? "" line) (loop r)]
                [r (error-exit "~a produced two output lines:\n  ~a\n  ~a"
                               cmd r line)]
                [else (loop line)])))))
  (unless (and username (not (equal? "" username)))
    (show-input-screen "Error: bad username"))
  (unless (and passwd1 (not (equal? "" passwd1)))
    (show-input-screen "Error: empty password"))
  (unless (equal? passwd1 passwd2)
    (show-input-screen "Error: mismatched passwords"))
  (when (and comment secret)
    (error-exit "Bad fields"))
  (let ([htpasswd
         (run-passwd "htpasswd" "-nb" username passwd1)]
        [htdigest
         (run-passwd "python" "-c" htdigest-wrapper
                     username htdigest-realm passwd1)]
        [style "background-color=\"#c0c0c0\"; color=\"black\""])
    (send-mail-message (format "~a@~a" username domain)
                       (format "Password request for `~a'" username)
                       (list admin-email) '() '()
                       (list (format "htpasswd: ~s" htpasswd)
                             (format "htdigest: ~s" htdigest)
                             ""
                             (format "~a: ~a"
                                     (if comment "Comment" "Secret")
                                     (or comment secret))))
    (write-page/exit "Password Set"
      `(p ()
         "Your magic lines are:"
         (blockquote ()
           (pre ([style ,style])
             ,(format "htpasswd line: ~s\nhtdigest line: ~s\n"
                      htpasswd htdigest)))
         "They have been sent to the administrator, and you will be"
         " notified when they are set.")
      (if secret
        ""
        `(p ()
           (b "Note:")
           " this service did not require authentication, so email the"
           " administrator and let him/her know that you filled this form."
           " (Unless you wrote an identifying comment.)")))))

(current-directory "/tmp")
(if (or passwd1 passwd2) (show-passwd-lines) (show-input-screen))
