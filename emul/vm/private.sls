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

(define (sign-extend i)
  (define sign-bit-pos (- (* size-of-pointer 8) 1))
  (define mask (bitwise-arithmetic-shift-left -1 sign-bit-pos))
  (define sign-bit (bitwise-arithmetic-shift-left 1 sign-bit-pos))
  (if (= 0 (bitwise-and sign-bit i))
    i
    (bitwise-ior mask i)))

(define (unword x)
  (cond
    ((pointer? x) 
     (sign-extend
       (pointer->integer x)))
    ((flonum? x) x)
    (else
      (assertion-violation
        'unword
        "Invalid object for unword"
        x))))
)
