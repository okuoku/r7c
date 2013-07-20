(library (emul heap type symbols)
         (export 
           symbol?
           symbol->string
           string->symbol
           symbol=?/2)
         (import (emul heap type booleans)
                 (emul heap type generic-vectors)
                 (emul heap tagwords)
                 (emul heap heapcommon)
                 (emul heap type fixnums)
                 (emul heap type strings)
                 (emul vm core))

(define (symbol? obj)
  (boolean (heap-vector-type? obj (imm 5))))
(define (require-string v)
  (%if (string? v)
       (values) ;; OK
       (err "String required")))
(define (require-symbol v)
  (%if (symbol? v)
       (values) ;; OK
       (err "Symbol required")))

(define (symbol=?/2 symbol1 symbol2)
  (boolean (eq symbol1 symbol2)))

(define (relabel h count) ;; FIXME: Should go to heapcommon
  (let ((cell (heap-cell h))) 
    (let ((cellsize (cell-size cell))) 
      (let ((w (pvector-word (imm count) cellsize)))
        (cell-write! cell (imm 0) w)))))

(define (symbol->string symbol)
  (require-symbol symbol)
  (let ((s (heap-vector-copy symbol)))
    ;; Re-label as string
    (relabel s 6)
    s))

(define (string->symbol string)
  (require-string string)
  (let ((s (heap-vector-copy string)))
    ;; Re-label as symbol
    (relabel s 5)
    ;; intern it
    ;; FIXME: Should go to heapcommon
    (new-heap-vector/cell (cell-intern0 (heap-cell s)) (imm 5))
    ))

)
