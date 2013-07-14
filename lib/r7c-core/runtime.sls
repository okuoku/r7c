(library (r7c-core runtime)
         (export
           ;; core
           not
           ;; lists
           list
           ;; pairs
           pair?
           cons
           car
           cdr
           caar
           cadr
           cdar
           cddr
           set-car!
           set-cdr!
           null?
           ;; values
           call-with-values
           values)
         (import (r7c-impl runtime core)
                 (r7c-impl runtime lists)
                 (r7c-impl runtime pairs)
                 (r7c-impl runtime values)))
