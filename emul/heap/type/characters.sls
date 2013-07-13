(library (emul heap type characters)
         (export 
           char?
           char->integer
           integer->char
           char=?/2
           char<?/2
           char>?/2
           char<=?/2
           char>=?/2)
         (import (emul heap type booleans)
                 (emul heap type fixnums)
                 (emul heap tagwords)
                 (emul vm core))


(define (char? obj)
  (boolean
    (if (zone1? obj)
      (receive (N V) (zone1-values obj)
        (eq N (imm 1)))
      (imm 0))))
(define (char->integer char)
  (%if (char? char)
       (receive (N V) (zone1-values obj)
         (fixnum V))
       (err "Char required")))
(define (integer->char n)
  (let ((i (fixnum-value n)))
    (zone1-word (imm 1) i)))

(define-syntax def
  (syntax-rules ()
    ((_ nam fixnum-equiv)
     (define (nam a b)
       (let ((x (char->integer a))
             (y (char->integer b)))
         (fixnum-equiv x y))))))

(def char=?/2 fx=?)
(def char<?/2 fx<?)
(def char>?/2 fx>?)
(def char<=?/2 fx<=?)
(def char>=?/2 fx>=?)
)
