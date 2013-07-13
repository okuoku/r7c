(library (emul vm heap)
         (export
           heap-cell
           cell-wordsize
           cell
           cell-read
           cell-write!
           cell-size)
         (import (rnrs)
                 (srfi :42)
                 (emul vm private)
                 (nmosh pffi interface))

(define (cell x)
  (define size (unword x))
  (object->pointer
    (vector-ec (: i size) (integer->pointer 0))))
(define (uncell x)
  (define obj (pointer->object x))
  (unless (vector? x)
    (assertion-violation 'uncell
                         "Invalid object for uncell"
                         obj))
  obj)

(define (cell-read x y)
  (define cell (uncell x))
  (define idx (unword x))
  (vector-ref cell idx))

(define (cell-write! x y value)
  (define cell (uncell x))
  (define idx (unword x))
  (vector-set! cell idx value))

(define (cell-size x)
  (define cell (uncell x))
  (word (vector-length cell)))

(define cell-wordsize 
  (word size-of-pointer))

)
