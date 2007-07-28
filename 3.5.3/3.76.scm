(load "smooth.scm")
(load "noisy-signal.scm")
(load "make-zero-crossings-smooth.scm")

(define modular-smoothed (stream->list (make-zero-crossings-smooth noisy-signal smooth)))

(test
 "modularly smoothed data"
 '(0 0 0 -1 0)
 modular-smoothed
 'equal?
 equal?)