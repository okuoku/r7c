(library (emul vm heap)
         (export
           cell-copy
           cell-u8-read
           cell-u8-write!
           cell-wordsize
           cell
           cell-read
           cell-write!
           cell-size)
         (import (rnrs)
                 (srfi :8)
                 (srfi :42)
                 (emul vm private)
                 (nmosh pffi interface))

(define (cell x)
  (define size (unword x))
  (define ptr
    (object->pointer
      (vector-ec (: i size) (integer->pointer 0))))
  ;(write (list 'new-cell: ptr))(newline)
  ptr)
(define (uncell x)
  (define obj (pointer->object x))
  (unless (vector? obj)
    (assertion-violation 'uncell
                         "Invalid object for uncell"
                         obj))
  obj)

(define (cell-read x y)
  (define cell (uncell x))
  (define idx (unword y))
  (vector-ref cell idx))

(define (cell-write! x y value)
  (define cell (uncell x))
  (define idx (unword y))
  (vector-set! cell idx value))

(define (calc-u8offsets byteidx)
  (values
    (div byteidx size-of-pointer)
    (mod byteidx size-of-pointer)))

(define (u8-read-word+byte cell byte-idx)
  ;; Always use little-endian
  (receive (w b) (calc-u8offsets byte-idx)
    (let ((p (pointer->integer (vector-ref cell w))))
      (let ((m (bitwise-and #xff (bitwise-arithmetic-shift-right
                                   p
                                   (* 8 b)))))
        (values p m)))))

(define (cell-u8-read x y)
  (define cell (uncell x))
  (define byte-idx (unword y))
  (receive (w b) (u8-read-word+byte cell byte-idx)
    (word b)))

(define (cell-u8-write! x y z)
  (define cell (uncell x))
  (define byte-idx (unword y))
  (define a (unword z))
  (unless (and (<= a 255) (>= a 0))
    (assertion-violation 'cell-u8-write
                         "Invalid argument"
                         a))
  (receive (w b) (calc-u8offsets byte-idx)
    (receive (n m) (u8-read-word+byte cell byte-idx)
      (let* ((mask (bitwise-not (bitwise-arithmetic-shift-left #xff (* 8 b))))
             (i (bitwise-arithmetic-shift-left a (* 8 b)))
             (r (bitwise-ior (bitwise-and mask w) i)))
        (cell-write! x y r)))))

(define (cell-size x)
  (define cell (uncell x))
  (word (vector-length cell)))

(define cell-wordsize 
  (word size-of-pointer))
(define (cell-copy x)
  (define cell (uncell x))
  (object->pointer (list->vector (vector->list cell))))

)
