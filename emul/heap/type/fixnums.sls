(library (emul heap type fixnums)
         (export 
           fixnum?
           fx+
           fx-
           fx<?
           fx>?
           fx<=?
           fx=?
           fixnum-value
           fixnum)
         (import (emul heap type booleans)
                 (emul heap tagwords)
                 (emul vm core))

(define (fixnum? x) (boolean (pfixnum? x)))
(define (fixnum x) (pfixnum-word x))
(define (fixnum-value x)
  (%if (fixnum? x)
       (err "fixnum required")
       (pfixnum-value x)))

(define-syntax def
  (syntax-rules ()
    ((_ nam (a b) conv body ...))
    (define (nam x y)
      (let ((a (fixnum-value x))
            (b (fixnum-value y)))
        (conv (let () body ...)))) ))

(def fx+ (x y) fixnum (add x y))
(def fx- (x y) fixnum (sub x y))
(def fx<? (x y) boolean (i< x y))
(def fx>? (x y) boolean (i> x y))
(def fx<=? (x y) boolean (i<= x y))
(def fx>=? (x y) boolean (i>= x y))
(def fx=? (x y) boolean (eq x y))

)
