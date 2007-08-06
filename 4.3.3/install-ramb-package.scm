(load "put.scm")
(load "amb-choices.scm")
(load "analyze.scm")
(load "randomize.scm")

(define (install-ramb-package)
  (define (analyze-ramb exp)
    (let ((cprocs (map analyze (amb-choices exp))))
      (lambda (env succeed fail)
        (define (try-next choices)
          (if (null? choices)
              (fail)
              ((car choices) env
               succeed
               (lambda ()
                 (try-next (cdr choices))))))
        (try-next (randomize cprocs)))))
  (put 'amb analyze-ramb))
