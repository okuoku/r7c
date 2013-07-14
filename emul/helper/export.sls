(library (emul helper export)
         (export export import)
         (import (rnrs)
                 (srfi :42)
                 (srfi :8)
                 (prefix (emul vm private) private-)
                 (prefix (emul heap type booleans) target-) 
                 (prefix (emul heap type characters) target-) 
                 (prefix (emul heap type fixnums) target-) 
                 (prefix (emul heap type pairs) target-) 
                 (prefix (emul heap type strings) target-) 
                 (prefix (emul heap type vectors) target-) )
         
        
(define (%b proc obj)
  ;; Convert target bool predicate into host bool
  (target-%if (proc obj)
              #t
              #f))

(define (import target-sexp)
  (cond
    ((%b target-boolean? target-sexp)
     (target-%if target-sexp
                 #t
                 #f))
    ((%b target-char? target-sexp)
     (integer->char 
       (private-unword
         (target-char->integer target-sexp))))
    ((%b target-fixnum? target-sexp)
     (private-unword (target-fixnum-value target-sexp)))
    ((%b target-null? target-sexp) '())
    ((%b target-pair? target-sexp)
     (cons (import (target-car target-sexp))
           (import (target-cdr target-sexp))))
    ((%b target-string? target-sexp)
     (receive (p proc) (open-string-output-port)
       (do-ec (: i (import (target-string-length target-sexp)))
              (put-char p (target-string-ref target-sexp (export i))))
       (proc)))
    ((%b target-vector? target-sexp)
     (list->vector (list-ec (: i (import (target-vector-length target-sexp)))
                            (target-vector-ref target-sexp (export i)))))
    (else
      (assertion-violation 'import
                           "Unkown datum"
                           target-sexp))))

(define (export sexp)
  (cond
    ((boolean? sexp)
     (if sexp
       (target-true)
       (target-false)))
    ((char? sexp)
     (target-integer->char
       (export (char->integer sexp))))
    ((number? sexp) 
     (target-fixnum (private-word sexp)))
    ((null? sexp) (target-null))
    ((pair? sexp)
     (target-cons (export (car sexp))
                  (export (cdr sexp))))
    ((string? sexp)
     (let* ((len (string-length sexp))
            (nex (target-make-string/undefined len)))
       (do-ec (: i len)
              (let ((c (string-ref sexp i)))
                (target-string-set! nex (export i) (export c)) ))
       nex))
    (else
      (assertion-violation 'export
                           "Unknown datum"
                           sexp))))         
         
)
