(library (emul heap type pairs)
         (export 
           pair?
           cons
           car
           cdr
           set-car!
           set-cdr!
           null?
           null)
         (import (emul heap type booleans)
                 (emul heap tagwords)
                 (emul heap heapcommon)
                 (emul vm core))

(define (null? obj)
  (boolean (if (zone0? obj)
             (eq (imm 3) (zone0-value obj))
             (imm 0))))
(define (null)
  (zone0-word (imm 3))) 

(define (pair? obj)
  (boolean (heap-vector-type? obj (imm 3))))
(define (set-car! pair obj)
  (%if (pair? pair)
       (heap-vector-write! pair (imm 0) obj)
       (err "Pair required")))
(define (set-cdr! pair obj)
  (%if (pair? pair)
       (heap-vector-write! pair (imm 1) obj)
       (err "Pair required")))
(define (cons obj1 obj2)
  (let ((v (new-heap-vector (imm 3) (imm 2))))
    (set-car! v obj1)
    (set-cdr! v obj2)
    v))
(define (car pair)
  (%if (pair? pair)
       (heap-vector-read pair (imm 0))
       (err "Pair required")))
(define (cdr pair)
  (%if (pair? pair)
       (heap-vector-read pair (imm 1))
       (err "Pair required")))
)
