#!/usr/bin/env nmosh
(import (rnrs) (emul helper export)
        (shorten)
        (mosh test)
        (only (emul vm core) imm)
        (emul heap tagwords)
        (srfi :8)
        (prefix (emul heap type fixnums) target-)
        (emul helper bridge)
        )

(define (try x)
  ;(write (list 'TRY: x))(newline)
  (let ((r (export x)))
    ;(write (list 'EXPORT: r "(target form)"))(newline)
    (let ((o (import r)))
      ;(write (list 'IMPORT: o "(host form)" 
      ;             (if (equal? x o) "OK!" "NG!")))(newline)
      o)))
(define test-basic '(#\a 0 "a1bc" 123 0 1 
                     0 1 2 3 4 5 6 7 8 9 10 11 12
                     0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10
                     -11 -12 -123 -1024
                     () #t #f #\C #\a (1 . 2) #() #("a" 1)))

;;; SANITY

#|
(define w (pvector-word (imm 4) (imm 5)))
(receive (T V) (pvector-values w)
  (write (list 'w: w '=> 'T: T 'V: V))(newline))
|#

;;; TESTS

;; IMPORT/EXPORT
(for-each (^e (test-equal e (try e))) test-basic)
(test-equal test-basic (try test-basic))

;; FIXNUM
(def/out i+ target-fx+)
(def/out i- target-fx-)
(def/out i= target-fx=?)

(test-equal (+ 1 2) (i+ 1 2))
(test-equal (= 3 (+ 1 2)) (i= 3 (i+ 1 2)))
(test-equal (- 1 2) (i- 1 2))

(test-results)
