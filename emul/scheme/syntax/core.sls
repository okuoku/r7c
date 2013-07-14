(library (emul scheme syntax core)
         (export 
           syntax-rules _ ...
           define
           let/core
           if
           begin
           quote
           )
         (import 
           (emul heap type specials)
           (emul helper export)
           (emul helper bridge)
           (except (rename (emul vm core)
                           (define core-define)
                           (let let/core))
                   if)
           ;; FIXME: how do we handle them?
           (only (rnrs)
                 let-syntax
                 letrec-syntax)
           (prefix (only (rnrs) 
                         lambda
                         quote) rnrs-))

(define-syntax lambda
  (syntax-rules ()
    ((_ var body ...)
     (bridge/out (rnrs-lambda var body ...)))))

(define-syntax define
  (syntax-rules ()
    ((_ (nam var ...) body ...)
     (core-define nam (lambda (var ...) body ...)))
    ((_ (nam var . last) body ...)
     (core-define nam (lambda (var . last) body ...)))
    ((_ (nam) body ...)
     (core-define nam (lambda () body ...)))
    ((_ nam dat)
     (core-define nam dat))))

(define-syntax quote
  (syntax-rules ()
    ((_ obj)
     (export (rnrs-quote obj)))))

(define-syntax if
  (syntax-rules ()
    ((_ e a)
     (if e a (unspeficied)))
    ((_ e a b)
     (%if e a b))))

)
