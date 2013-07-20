;; 6.5. Symbols
(library (r7c-impl runtime symbols)
         (export
           symbol?
           symbol->string
           string->symbol
           symbol=?/2
           )
         (import (emul helper bridge)
                 (emul scheme syntax core)
                 (prefix (emul heap type symbols) target-))

(def/out symbol? target-symbol?)
(def/out symbol->string target-symbol->string)
(def/out string->symbol target-string->symbol)
(def/out symbol=?/2 target-symbol=?/2)

)
