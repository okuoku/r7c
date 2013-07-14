;; 6.4. Pairs and lists
(library (r7c-impl runtime pairs)
         (export
           pair?
           cons
           car
           cdr
           caar
           cadr
           cdar
           cddr
           set-car!
           set-cdr!
           null?)
         (import (emul helper bridge)
                 (emul scheme syntax core)
                 (prefix (emul heap type pairs) target-))

(def/out pair? target-pair?)
(def/out cons target-cons)
(def/out car target-car)
(def/out cdr target-cdr)
(def/out set-car! target-set-car!)
(def/out set-cdr! target-set-cdr!)

(define (caar pair) (target-car (target-car pair)))
(define (cadr pair) (target-car (target-cdr pair)))
(define (cdar pair) (target-cdr (target-car pair)))
(define (cddr pair) (target-cdr (target-cdr pair)))

)
