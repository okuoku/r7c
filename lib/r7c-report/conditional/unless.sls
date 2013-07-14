(library (r7c-report conditional unless)
         (export unless)
         (import (r7c-impl syntax core)
                 (only (r7c-impl runtime core) not))


;; Took from 7.3 Derived expression types
(define-syntax unless
  (syntax-rules ()
    ((unless test result1 result2 ...)
     (if (not test)
       (begin result1 result2 ...)))))
)
