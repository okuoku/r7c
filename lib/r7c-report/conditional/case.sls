(library (r7c-report conditional case)
         (export case else =>)
         (import 
           (r7c-impl syntax core)
           (only (r7c-impl runtime lists) memv))


;; Took from 7.3 Derived expression types
(define-syntax case
  (syntax-rules (else =>)
    ((case (key ...) clauses ...)
     (let ((atom-key (key ...)))
       (case atom-key clauses ...)))
    ((case key (else => result))
     (result key))
    ((case key (else result1 result2 ...))
     (begin result1 result2 ...))
    ((case key ((atoms ...) result1 result2 ...))
     (if (memv key '(atoms ...))
       (begin result1 result2 ...)))
    ((case key ((atoms ...) => result))
     (if (memv key ’(atoms ...))
       (result key)))
    ((case key ((atoms ...) => result) clause clauses ...)
     (if (memv key ’(atoms ...))
       (result key)
       (case key clause clauses ...)))
    ((case key ((atoms ...) result1 result2 ...) clause clauses ...)
     (if (memv key ’(atoms ...))
       (begin result1 result2 ...)
       (case key clause clauses ...)))))
)
