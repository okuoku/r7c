;; 6.7. Strings
(library (r7c-impl runtime strings)
         (export
           string?
           string-length
           string-ref
           string-set!
           make-string/undefined
           string-copy/1
           )
         (import (emul helper bridge)
                 (emul scheme syntax core)
                 (prefix (emul heap type strings) target-))

(def/out string? target-string?)
(def/out string-length target-string-length)
(def/out string-ref target-string-ref)
(def/out string-set! target-string-set!)
(def/out make-string/undefined target-make-string/undefined)
(def/out string-copy/1 target-string-copy/1)

)
