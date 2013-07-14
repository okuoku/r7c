;; Construct your Core scheme library here.
(library (r7c-impl syntax core)
         (export
           ;;
           quote

           ;;
           lambda

           ;; 
           set!

           ;; AUX keywords
           else => ...

           ;; 
           begin

           ;;
           if

           ;;
           syntax-rules
           define-syntax

           ;; Binding constructs
           (rename (let let/core))
           )
         (import (except (emul vm core) if)
                 (emul syntax aux)
                 )
)
