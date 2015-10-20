#!/usr/bin/env chicken-scheme
(use test)

(define (inc n) (+ n 1))

(define (accumulate combiner null-value term a next b)
  (let iter ((a a)
             (result null-value))
    (if (> a b)
        result
        (iter (next a)
              (combiner result (term a))))))

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

(test 15 (sum identity 0 inc 5))
(test 120 (product identity 1 inc 5))
