(define integral
  (list
   '(define (integral integrand initial-value dt)
      (define int
        (cons initial-value
              (add-lists (scale-list integrand dt)
                         int)))
      int)
   '(define (solve f y0 dt)
      (letrec ((y (integral dy y0 dt))
               (dy (map f y)))
        y))
   '(define ones (cons 1 ones))
   '(define integers (cons 1 (add-lists ones integers)))))