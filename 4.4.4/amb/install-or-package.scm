(define (install-or-package)
  (define (analyze-or exp)
    (analyze (or->if exp)))
  (put-amb 'or analyze-or)
  'done)
