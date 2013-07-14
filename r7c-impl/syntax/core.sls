;; Construct your Core scheme library here.
(library (r7c-impl syntax core)
         (export
           ;;
           quote

           ;;
           define
           lambda

           ;; 
           set!

           ;; AUX keywords
           else => ... _

           ;; 
           begin

           ;;
           if

           ;;
           syntax-rules
           define-syntax
           let-syntax
           letrec-syntax

           ;; Binding constructs
           let/core
           )
         (import (except (emul vm core) define if)
                 (emul scheme syntax core))
)
