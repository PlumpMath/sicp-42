(define (install-assignment-package)
  (define (analyze-assignment exp)
    (let ((var (assignment-variable exp))
          (vproc (analyze (assignment-value exp))))
      (lambda (env succeed fail)
        (vproc env
               (lambda (val fail2)        ; *1*
                 (let ((old-value
                        (lookup-variable-value var env))) 
                   (set-variable-value! var val env)
                   (succeed 'ok
                            (lambda ()    ; *2*
                              (set-variable-value! var
                                                   old-value
                                                   env)
                              (fail2)))))
               fail))))
  (put-amb 'set! analyze-assignment)
  'done)
