#!/usr/bin/env chicken-scheme
(use sicp test)

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (square-root (add (square (real-part z))
                      (square (imag-part z)))))
  (define (angle z)
    (arctan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z) (mul (magnitude z) (cosine (angle z))))
  (define (imag-part z) (mul (magnitude z) (sine (angle z))))
  (define (make-from-real-imag x y)
    (cons (square-root (add (square x) (square y)))
          (atan y x)))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-complex-package)
  (install-polar-package)
  (install-rectangular-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2))))
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)
  'done)

;;; Should have done this using coercion; also, should have tried to
;;; preserve types?
(define (install-trigonometric-etc-package)
  (define (tag-scheme-number object)
    (attach-tag 'scheme-number object))
  (put 'arctan '(scheme-number)
       (lambda (n) (tag-scheme-number (atan n))))
  (put 'arctan '(rational)
       (lambda (n) (tag-scheme-number (atan (/ (numer n) (denom n))))))
  (put 'sine '(scheme-number)
       (lambda (n) (tag-scheme-number (sin n))))
  (put 'sine '(rational)
       (lambda (n) (tag-scheme-number (sin (/ (numer n) (denom n))))))
  (put 'cosine '(scheme-number)
       (lambda (n) (tag-scheme-number (cos n))))
  (put 'cosine '(rational)
       (lambda (n) (tag-scheme-number (cos (/ (numer n) (denom n))))))
  (put 'square '(scheme-number)
       (lambda (n) (tag-scheme-number (* n n))))
  (put 'square '(rational)
       (lambda (n) (let ((n (/ (numer n) (denom n))))
                (tag-scheme-number (* n n)))))
  (put 'square-root '(scheme-number)
       (lambda (n) (tag-scheme-number (sqrt n))))
  (put 'square-root '(rational)
       (lambda (n) (tag-scheme-number
               (sqrt (/ (numer n) (denom n)))))))

(define (arctan x) (apply-generic 'arctan x))
(define (cosine x) (apply-generic 'cosine x))
(define (sine x) (apply-generic 'sine x))
(define (square x) (apply-generic 'square x))
(define (square-root x) (apply-generic 'square-root x))

(install-scheme-number-package)
(install-rational-package)
(install-complex-package)
(install-trigonometric-etc-package)

(let* ((rational (make-rational 1 2))
       (complex (make-complex-from-real-imag rational rational)))
  (test '(complex rectangular (rational 1 . 1) rational 1 . 1)
        (add complex complex)))
