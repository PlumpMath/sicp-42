(define (install-and-package)
  (define (analyze-and exp)
    (analyze (and->if exp)))
  (put-amb 'and analyze-and)
  'done)
