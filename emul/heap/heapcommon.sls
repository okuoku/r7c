(library (emul heap heapcommon)
         (export
           new-heap-vector/cell
           new-heap-vector
           ;new-heap-buffer
           heap-vector-type?
           ;heap-buffer-type?
           heap-cell
           heap-vector-read
           heap-vector-write!
           heap-vector-copy
           heap-vector-size
           )
         (import (emul heap tagwords)
                 (emul vm core))

(define true (imm 1))
(define false (imm 0))

(define (checkptr w)
  (if (eq (imm 0) (band (imm #b111) w))
    (values) ;; OK
    (err "Invalid pointer")))

(define (new-heap-vector/cell cell type)
  (let ((cellsize (cell-size cell))) 
    (let ((w (pvector-word type cellsize)))
      (checkptr cell)
      (cell-write! cell (imm 0) w)
      (heap-object-word cell))))

(define (new-heap-vector type size)
  (let ((newsize (add (imm 1) size)))
    (let ((newcell (cell newsize))
          (w (pvector-word type size)))
      (checkptr newcell)
      (cell-write! newcell (imm 0) w)
      (heap-object-word newcell))))

(define (heap-cell w)
  (if (heap-object? w)
    (heap-object-value w)
    (err "Heap object required")))

(define (heap-vector-size w)
  (let ((c (heap-cell w)))
    (sub (cell-size c) (imm 1))))

(define (heap-vector-type w)
  (if (heap-object? w)
    (let ((c (heap-cell w)))
      (let ((w (cell-read c (imm 0))))
        (if (pvector? w)
          (receive (T V) (pvector-values w)
            T)
          (err "Invalid heap header"))))
    (err "Heap object required")))

(define (heap-vector-type? w type)
  (if (heap-object? w)
    (let ((c (heap-cell w)))
      (let ((w (cell-read c (imm 0))))
        (if (pvector? w)
          (receive (T V) (pvector-values w)
            (eq type T))
          false)))
    false))

(define (heap-vector-read w idx)
  (cell-read (heap-cell w) (add (imm 1) idx)))
(define (heap-vector-write! w idx obj)
  (cell-write! (heap-cell w) (add (imm 1) idx) obj))
(define (heap-vector-copy w)
  (let ((n (cell-copy (heap-cell w)))
        (t (heap-vector-type w)))
    (new-heap-vector/cell n t)))

)
