#!/usr/bin/env chicken-scheme
(use debug sicp sicp-eval sicp-eval-amb test)

(define (permanent-assignment? exp) (tagged-list? exp 'permanent-set!))

(define (analyze-permanent-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)
               (set-variable-value! var val env)
               (succeed 'ok fail2))
             fail))))

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((permanent-assignment? exp) (analyze-permanent-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((let-clause? exp) (analyze-let exp))
        ((if? exp) (analyze-if exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp))))

(with-require `((+ ,+)
                (eq? ,eq?)
                (list ,list))
  (lambda (env)
    (ambeval* '(define count 0) env)
    (test "Permanent-set!"
          '((a b 2) (a c 3) (b a 4) (b c 6) (c a 7) (c b 8))
          (ambeval* '(let ((x (an-element-of '(a b c)))
                           (y (an-element-of '(a b c))))
                       (permanent-set! count (+ count 1))
                       (require (not (eq? x y)))
                       (list x y count))
                    env))
    
    (ambeval* '(define count 0) env)
    (test "Non-permanent-set!"
          '((a b 1) (a c 1) (b a 1) (b c 1) (c a 1) (c b 1))
          (ambeval* '(let ((x (an-element-of '(a b c)))
                           (y (an-element-of '(a b c))))
                       (set! count (+ count 1))
                       (require (not (eq? x y)))
                       (list x y count))
                    env))))
