(library (emul heap type booleans)
         (export not boolean? boolean=?/2
                 true false
                 %if eq-boolean)
         (import (emul vm core)
                 (emul heap tagwords))

(define (true) (zone0-word 1))
(define (false) (zone0-word 2))

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

(define-syntax %if
  (syntax-rules ()
    ((_ f a b)
     (let ((obj f))
       (if (zone0? obj)
         (if (eq (zone0-value obj) 2)
           b
           a))))))

(define (boolean=?/2 boolean1 boolean2)
  (%if (boolean? boolean1)
       (%if (boolean? boolean2)
            (boolean 
              (eq (zone0-value boolean1)
                  (zone1-value boolean2)))
            (err "boolean2"))
       (err "boolean1")))

(define (not obj)
  (%if obj (false) (true)))

)
