(library (emul vm private)
         (export word unword)
         (import (rnrs)
                 (nmosh pffi interface))

(define (word x)
  (cond
    ((boolean? x)
     (if x
       (word 1)
       (word 0)))
    ((integer? x)
     (integer->pointer x))
    ((flonum? x)
     x)
    ((pointer? x)
     x)
    (else
      (assertion-violation
        'word
        "Invalid object for word"
        x)))) 

(define (unword x)
  (cond
    ((pointer? x) (pointer->integer x))
    ((flonum? x) x)
    (else
      (assertion-violation
        'unword
        "Invalid object for unword"
        x))))
)
