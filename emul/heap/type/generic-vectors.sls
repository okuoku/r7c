(library (emul heap type generic-vectors)
         (export
           gvector-length
           gvector-ref
           gvector-set!
           make-gvector/default
           gvector-copy/1)
         (import (emul heap type booleans)
                 (emul heap tagwords)
                 (emul heap heapcommon)
                 (emul heap fixnums)
                 (emul vm core))

(define (gvector-length vector)
  (fixnum (heap-vector-size vector)))
(define (gvector-ref vector k)
  (heap-vector-read vector (fixnum-value k)))
(define (gvector-set! vector k obj)
  (heap-vector-write! vector (fixnum-value k) obj))
(define (make-gvector/default type k fill)
  (let ((v (new-heap-vector type (fixnum-value k))))
    v))

)
