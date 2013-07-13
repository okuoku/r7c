(library (r7c-report misc case-lambda)
         (export case-lambda)
         (import (r7c-impl syntax core)
                 (r7c-impl runtime core)
                 (r7c-impl runtime pairs)
                 (r7c-impl runtime lists)
                 (r7c-impl syntax let)
                 (r7c-impl runtime error)
                 (r7c-impl runtime callcc)
                 (r7c-impl runtime values)
                 )

;; Took from 7.3 Derived expression types

(define-syntax case-lambda
  (syntax-rules ()
    ((case-lambda (params body0 ...) ...)
     (lambda args
       (let ((len (length args)))
         (let-syntax
           ((cl (syntax-rules ::: ()
                  ((cl)
                   (error "no matching clause"))
                  ((cl ((p :::) . body) . rest)
                   (if (= len (length '(p :::)))
                     (apply (lambda (p :::)
                              . body)
                            args)
                     (cl . rest)))
                  ((cl ((p ::: . tail) . body)
                       . rest)
                   (if (>= len (length '(p :::)))
                     (apply
                       (lambda (p ::: . tail)
                         . body)
                       args)
                     (cl . rest))))))
           (cl (params body0 ...) ...)))))))

)
