(library (r7c-report misc do)
         (export do)
         (import (r7c-impl syntax core)
                 (r7c-report binding-construct letrec))

;; Took from 7.3 Derived expression types
(define-syntax do
  (syntax-rules ()
    ((do ((var init step ...) ...)
       (test expr ...)
       command ...)
     (letrec
       ((loop
          (lambda (var ...)
            (if test
              (begin
                (if '#f '#f)
                expr ...)
              (begin
                command
                ...
                (loop (do "step" var step ...)
                      ...))))))
       (loop init ...)))
    ((do "step" x)
     x)
    ((do "step" x y)
     y)))

)
