(library (emul heap type vectors)
         (export 
           vector?
           vector-length
           vector-ref
           vector-set!
           make-vector/undefined
           vector-copy/1)
         (import (emul heap type booleans)
                 (emul heap type generic-vectors)
                 (emul heap tagwords)
                 (emul heap heapcommon)
                 (emul heap fixnums)
                 (emul vm core))

(define (vector? obj)
  (boolean (heap-vector-type? obj (imm 2))))
(define (require-vector v)
  (%if (vector? v)
       (values) ;; OK
       (err "Vector required")))

(define (vector-length vector)
  (require-vector vector)
  (gvector-length vector))

(define (vector-ref vector k)
  (require-vector vector)
  (gvector-ref vector k))
(define (vector-set! vector k obj)
  (require-vector vector)
  (gvector-set! vector k obj))
(define (make-vector/undefined k)
  (make-gvector (imm 2) k))
(define (vector-copy/1 vector)
  (require-vector vector)
  (heap-vector-copy vector))

)
