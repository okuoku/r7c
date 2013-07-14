(library (r7c-report misc parameterize)
         (export parameterize make-parameter)
         (import (r7c-impl syntax core)
                 (r7c-impl runtime pairs)
                 (r7c-impl syntax unless)
                 (r7c-impl syntax let)
                 (r7c-impl runtime error)
                 (r7c-impl runtime callcc)
                 )


;; FIXME: 
(define <param-set!> (list '"unique"))
(define <param-convert> (list '"unique"))

;; Took from 7.3 Derived expression types

(define (make-parameter init . o)
      (let* ((converter
              (if (pair? o) (car o) (lambda (x) x)))
             (value (converter init)))
        (lambda args
          (cond
           ((null? args)
            value)
           ((eq? (car args) <param-set!>)
            (set! value (cadr args)))
           ((eq? (car args) <param-convert>)
            converter)
           (else
            (error "bad parameter syntax"))))))

(define-syntax parameterize
  (syntax-rules ()
    ((parameterize ("step")
                   ((param value p old new) ...)
                   ()
                   body)
     (let/core ((p param) ...)
       (let/core ((old (p)) ...
                  (new ((p <param-convert>) value)) ...)
         (dynamic-wind
           (lambda () (p <param-set!> new) ...)
           (lambda () . body)
           (lambda () (p <param-set!> old) ...)))))
    ((parameterize ("step")
                   args
                   ((param value p old new) . rest)
                   body)
     (parameterize ("step")
                   ((param value p old new) . args)
                   rest
                   body))
    ((parameterize ((param value) ...) . body)
     (parameterize ("step")
                   ()
                   ((param value) ...)
                   body))))


)
