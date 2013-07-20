(library (emul vm core)
         (export
           values
           define-syntax
           syntax-rules
           _ ...
           define
           let
           receive
           if
           imm
           cell-intern0
           cell-wordsize
           cell
           cell-read
           cell-write!
           cell-size
           cell-copy
           cell-u8-read
           cell-u8-write!
           add
           sub
           mul
           div
           div+mod
           bior
           band
           bnot
           s<<
           s>>
           u<<
           u>>
           fadd
           fsub
           fmul
           fdiv
           eq
           i<
           i>
           i<=
           i>=
           f<
           f>
           f<=
           f>=
           err)
         (import (except (rnrs) div if)
                 (srfi :8)
                 (rename (only (rnrs) if) (if rnrs-if))
                 (emul vm private)
                 (emul vm arith)
                 (emul vm heap))
         
(define (imm x) 
  ;(write (list 'imm: x))(newline)
  (rnrs-if (flonum? x)
           (fword x)
           (word x))) 

(define (bool x)
  (not (= 0 x)))

(define-syntax if
  (syntax-rules ()
    ((_ q a b)
     (begin
       (unless (word? q)
         (assertion-violation
           'vm
           "Target bool required here"
           q))
       (rnrs-if (bool (unword q)) a b)))))

(define-syntax err
  (syntax-rules ()
    ((_ obj ...)
     (assertion-violation
       'vm
       "error"
       '(obj ...)))))

)
