(load "extend-environment.scm")
(load "define-variable!.scm")
(load "primitive-procedure-names.scm")
(load "primitive-procedure-objects.scm")
(load "the-empty-environment.scm")

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
