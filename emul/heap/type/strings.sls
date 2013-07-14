(library (emul heap type strings)
         (export 
           string?
           string-length
           string-ref
           string-set!
           make-string/undefined
           string-copy/1)
         (import (emul heap type booleans)
                 (emul heap type generic-vectors)
                 (emul heap tagwords)
                 (emul heap heapcommon)
                 (emul heap fixnums)
                 (emul vm core))

(define (string? obj)
  (boolean (heap-vector-type? obj (imm 6))))
(define (require-string v)
  (%if (string? v)
       (values) ;; OK
       (err "String required")))

(define (string-length string)
  (require-string string)
  (gvector-length string))
(define (string-ref string k)
  (require-string string)
  (gvector-ref string k))
(define (string-set! string k obj)
  (require-string string)
  (gvector-set! string k obj))
(define (make-string/undefined k)
  (make-gvector (imm 6) k))
(define (string-copy/1 string)
  (require-string string)
  (heap-vector-copy string))

)
