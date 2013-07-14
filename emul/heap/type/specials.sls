(library (emul heap type specials)
         (export 
           unspecified?
           unspecified
           undefined
           undefined?
           )
         (import (emul heap type booleans)
                 (emul heap tagwords)
                 (emul heap heapcommon)
                 (emul vm core))

(define (unspecified? obj)
  (boolean (if (zone0? obj)
             (eq (imm 5) (zone0-value obj))
             (imm 0))))
(define (unspecified)
  (zone0-word (imm 5))) 
(define (unspecified? obj)
  (boolean (if (zone0? obj)
             (eq (imm 6) (zone0-value obj))
             (imm 0))))
(define (unspecified)
  (zone0-word (imm 6))) 
)
