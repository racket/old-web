#reader"../common/html-script.ss"

(define (run)
  (unless (testing?)
    @write-raw*["robots.txt"]{
      # avoid indexing repository content
      User-agent: *
      Disallow: /plt/
      Disallow: /iplt/
      Disallow: /play/
      Disallow: /view/
      Disallow: /iview/}))
