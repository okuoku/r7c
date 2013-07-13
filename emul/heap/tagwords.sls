(library (emul heap tagwords)
         (export 
           pfixnum?
           pfixnum-value
           pfixnum-word
           heap-object-word
           heap-object-word/atomic
           heap-object?
           heap-object-value
           zone0-word
           zone0?
           zone0-value
           zone1-word
           zone1?
           zone1-values
           buffer-word
           buffer?
           buffer-values
           pvector-word
           pvector?
           pvector-values)
         (import (emul vm core))

(define true (imm 1))
(define false (imm 0))

;; FIXNUM
(define (pfixnum? w)
  (if (eq (imm 0) 
          (band w (imm 1)))
    true
    false))

(define (pfixnum-value w)
  (s>> w (imm 1)))

(define (pfixnum-word v)
  (s<< w (imm 1)))

;; HEAP-OBJECT
(define (heap-object-word/core w h)
  (bor w h))

(define (heap-object-word/atmic w)
  (heap-object-word/core w (imm #b011)))
(define (heap-object-word w)
  (heap-object-word/core w (imm #b001)))
(define (heap-object? w)
  (let ((l (band (imm #b111)
                 w)))
    (if (eq (imm #b001) l)
      true
      (if (eq (imm #b011) l)
        true
        false))))
(define (heap-object-value w)
  (band (bnot (imm #b111)) w))

;; ZONE0
(define (zone0-word N)
  (bor (s<< N (imm 4))
       (imm #b0111)))
(define (zone0? w)
  (eq (band (imm #b1111) w) 
      #b0111))
(define (zone0-value w)
  (s>> w (imm 4)))

;; ZONE1
(define (zone1-word N V)
  (let ((n (s<< (band (imm #b1111) N) (imm 4)))
        (v (s<< V (imm 8))))
    (bor (bor n v) (imm #b1111))))
(define (zone1? w)
  (eq (band (imm #b1111)
            w)
      (imm #b1111)))
(define (zone1-values w)
  (let ((v (s>> w (imm 8)))
        (n (band #b1111 (s>> w (imm 4)))))
    (values v n)))

;; BUFFER
(define (buffer-word T V)
  (let ((t (s<< (band T (imm #b11111111)) (imm 8)))
        (v (s<< V (imm 12))))
    (bor (bor t v) (imm #b1011))))
(define (buffer? w)
  (eq (band (imm #b1111)
            w)
      (imm #b1011)))
(define (buffer-values w)
  (let ((v (s>> w (imm 12)))
        (n (band #b11111111 (s>> w (imm 8)))))
    (values v n)))

;; PVECTOR
(define (pvector-word T V)
  (let ((t (s<< (band T (imm #b11111111)) (imm 8)))
        (v (s<< V (imm 12))))
    (bor (bor t v) (imm #b1111))))
(define (pvector? w)
  (eq (band (imm #b1111)
            w)
      (imm #b1111)))
(define (pvector-values w)
  (let ((v (s>> w (imm 12)))
        (n (band #b11111111 (s>> w (imm 8)))))
    (values v n)))

)
