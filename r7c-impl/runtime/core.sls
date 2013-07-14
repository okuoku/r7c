(library (r7c-impl runtime core)
         (export not)
         (import 
           (emul helper bridge)
           (prefix (emul heap type booleans) target-))

(def/out not target-not)

)
