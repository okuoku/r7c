(library (r7c-core deliv)
         (export
           let
           let*
           letrec
           letrec*
           let-values
           let*-values
           define-values
           and
           or
           ; case (relies memv)
           cond
           unless
           when
           )
         (import (r7c-report binding-construct let)
                 (r7c-report binding-construct letrec)
                 (r7c-report binding-construct let-values)
                 (r7c-report binding-construct define-values)
                 (r7c-report conditional and)
                 (r7c-report conditional or)
                 (r7c-report conditional cond)
                 (r7c-report conditional unless)
                 (r7c-report conditional when)
                 )
         )
