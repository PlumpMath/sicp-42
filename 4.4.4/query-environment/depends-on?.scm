(define (depends-on? exp var environment)
  (define (tree-walk e)
    (cond ((var? e)
           (if (equal? var e)
               true
               (if (environment-bound-symbol? environment e)
                   (tree-walk (environment-lookup-symbol environment e))
                   false)))
          ((pair? e)
           (or (tree-walk (car e))
               (tree-walk (cdr e))))
          (else false)))
  (tree-walk exp))
