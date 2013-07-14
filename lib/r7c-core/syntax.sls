;; Core syntax, which should have same semantics on R7RS
(library (r7c-core syntax)
         (export quote lambda set!
                 else => ...
                 _
                 begin
                 if
                 syntax-rules
                 define-syntax
                 let-syntax
                 letrec-syntax)
         (import (r7c-impl syntax core)))
