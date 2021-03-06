(library (emul heap type booleans)
         (export not boolean? boolean=?/2
                 true false
                 boolean
                 %if)
         (import (emul vm core)
                 (emul heap tagwords))

(define (true) (zone0-word (imm 1)))
(define (false) (zone0-word (imm 2)))

(define (boolean? obj)
  (if (zone0? obj)
    (let ((v (zone0-value obj)))
      (if (eq (imm 1) v)
        (true)
        (if (eq (imm 2) v)
          (true)
          (false))))
    (false)))

(define (boolean w0)
  (if w0
    (true)
    (false)))

(define (%if-check obj)
  (if (zone0? obj)
    (if (eq (zone0-value obj) (imm 2))
      (imm 0)
      (imm 1))
    (imm 1)))

(define-syntax %if
  (syntax-rules ()
    ((_ f a b)
     (let ((obj f))
       (if (eq (imm 0) (%if-check obj))
         b
         a)))))

(define (boolean=?/2 boolean1 boolean2)
  (%if (boolean? boolean1)
       (%if (boolean? boolean2)
            (boolean 
              (eq (zone0-value boolean1)
                  (zone0-value boolean2)))
            (err "boolean2"))
       (err "boolean1")))

(define (not obj)
  (%if obj (false) (true)))

)
