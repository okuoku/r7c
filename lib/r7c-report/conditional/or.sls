(library (r7c-report conditional or)
         (export or)
         (import (r7c-impl syntax core))


;; Took from 7.3 Derived expression types
(define-syntax or
  (syntax-rules ()
    ((or) #f)
    ((or test) test)
    ((or test1 test2 ...)
     (let ((x test1))
       (if x x (or test2 ...))))))
)
