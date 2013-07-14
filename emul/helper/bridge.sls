(library (emul helper bridge)
         (export bridge/out def/out)
         (import (rnrs) (shorten) (emul helper export))

(define-syntax def/out
  (syntax-rules ()
    ((_ nam src)
     (define nam (bridge/out src)))))

(define (bridge/out proc)
  ;; Create call bridge (host => target, call target proc from host)
  (^ in
     (call-with-values
       (^[] (apply proc (map export in)))
       (^ e (apply values (map import e))))))
         
)
