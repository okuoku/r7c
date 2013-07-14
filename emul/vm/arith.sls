(library (emul vm arith)
         (export
           add sub mul div
           div+mod
           bior
           band
           bnot
           s<< s>>
           u<< u>>
           fadd
           fsub
           fmul
           fdiv
           eq
           i< i> i<= i>=
           f< f> f<= f>=)
         (import (rename (rnrs)
                         (div rnrs-div))
                 (emul vm private)
                 (nmosh pffi interface))

(define-syntax def
  (syntax-rules ()
    ((_ nam (v ...) code ...)
     (define (nam v ...)
       (set! v (unword v))
       ...
       (let ((e (let () code ...)))
         (xword e))))))

(define (neg i) ;; Calc 2 complement
  (let* ((base (expt 2 (* 8 size-of-pointer)))
         (p (mod (bitwise-not i) base)))
    (- base 1 p)))

(define (xword e) ;; Allow negative values
  (word
    (if (and (integer? e) (< e 0))
      (neg e)
      e)))

(def add (x y) (+ x y))
(def sub (x y) (- x y))
(def mul (x y) (* x y))
(def div (x y) (rnrs-div x y))
(define (div+mod a b)
  (define x (unword a))
  (define y (unword b))
  (let ((i (div x y))
        (j (mod x y)))
    (values (word i)
            (word j))))
(define (sign-extend i)
  (cond
    ((or (= i 0) (positive? i))
     i)
    (else
      (let ((mask (bitwise-arithmetic-shift-left 
                    -1
                    (+ 1 (bitwise-first-bit-set i)))))
        (bitwise-ior mask i)))))

(def bior (x y) (bitwise-ior x y))
(def band (x y) (bitwise-and x y))
(def bxor (x y) (bitwise-xor x y))
(def bnot (x) (bitwise-not x))
(def s<< (x y) (bitwise-arithmetic-shift-left (sign-extend x) y))
(def s>> (x y) (bitwise-arithmetic-shift-right (sign-extend x) y))
(def u<< (x y) (bitwise-arithmetic-shift-left x y))
(def u>> (x y) (bitwise-arithmetic-shift-right x y))

(def fadd (x y) (+ x y))
(def fsub (x y) (- x y))
(def fmul (x y) (* x y))
(def fdiv (x y) (inexact (/ x y)))
(def eq (x y) (eq? x y))
(def i< (x y) (< x y))
(def i> (x y) (> x y))
(def i<= (x y) (<= x y))
(def i>= (x y) (>= x y))
(def f< (x y) (< x y))
(def f> (x y) (> x y))
(def f<= (x y) (<= x y))
(def f>= (x y) (>= x y))

)
