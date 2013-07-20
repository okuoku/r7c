(library (emul vm private)
         (export 
           word?
           fword
           funword
           word 
           uunword
           unword)
         (import (rnrs)
                 (nmosh ffi box)
                 (nmosh pffi interface))

(define (word? x) (pointer? x))

(define (flonum->f32 x)
  (let ((bv (make-bytevector 4)))
    (bytevector-ieee-single-native-set! bv 0 x)
    bv) )

(define (f32->flonum bv)
  (bytevector-ieee-single-native-ref bv 0))

(define (flonum->f64 x)
  (let ((bv (make-bytevector 8)))
    (bytevector-ieee-single-native-set! bv 0 x)
    bv))

(define (f64->flonum bv)
  (bytevector-ieee-single-native-ref bv 0))

(define (bv->ptrval bv)
  (ptr-box-ref bv))
(define (ptrval->bv p)
  (let ((b (make-ptr-box)))
    (ptr-box-set! b p)))

(define (fword x)
  (case size-of-pointer
    ((4)
     (bv->ptrval (flonum->f32 x)))
    (else
      (bv->ptrval (flonum->f64 x)))))

(define (funword x)
  (case size-of-pointer
    ((4)
     (f32->flonum (ptrval->bv x)))
    (else
      (f64->flonum (ptrval->bv x)))))

(define (word x)
  (cond
    ((boolean? x)
     (if x
       (word 1)
       (word 0)))
    ((integer? x)
     (integer->pointer x))
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
  (sign-extend (uunword x)))

(define (uunword x)
  (cond
    ((pointer? x) 
     (pointer->integer x))
    (else
      (assertion-violation
        'unword
        "Invalid object for unword"
        x))))
)
