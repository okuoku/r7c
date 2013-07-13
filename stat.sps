#!/usr/bin/env nmosh
(import (rnrs)
        (yuni core)
        (shorten)
        (match)
        (srfi :26)
        (srfi :48)
        (mosh pp)
        (srfi :8)
        (only (srfi :1) delete-duplicates)
        (yuni text tabular)
        (yuni util files))

(define* std-symbol-attr (section-name library defined))
(define rep (file->sexp-list "symbols.scm"))
(define libs (let ((e '()))
               (directory-walk
                 "lib"
                 (^p (and (string=? 
                            "sls"
                            (path-extension p)) (set! e (cons p e)))))
               e))

;; Construct symbols list

(define (lib-symbols pth)
  (define code (file->sexp-list pth))
  (match code
         ((('library name ('export exports ...) ('import hoge ...) bogus ...))
          exports)
         (else
           (format #t "Warning: ~a is not a library file!\n" pth)
           '())))

(define defined-symbols (delete-duplicates 
                          (apply append (map lib-symbols libs))))

(define std-symbol-ht (make-eq-hashtable))

(define (add-to-ht ent)
  (define (add head sym)
    (define pl (if (string? head) 'section-name 'library))
    (let ((e (hashtable-ref std-symbol-ht sym #f)))
      (cond
        (e
          (let-with e (section-name library)
            (when (and section-name library)
              (format #t "Warning: Something wrong! ~a\n"
                      (list sym '::: head '::: section-name library)))
            (~ e pl := head)))
        (else
          (let ((new (make std-symbol-attr 
                           (defined #f)
                           (section-name #f) 
                           (library #f))))
            (~ new pl := head)
            (hashtable-set! std-symbol-ht sym new))))))
  (match ent
         ((head . lis)
          (for-each (cut add head <>) lis))
         (else
           (format #t "Warning: Invalid entry format ~w\n" ent))))

(define (apply-defined sym)
  (let ((e (hashtable-ref std-symbol-ht sym #f)))
    (cond
      (e
        (~ e 'defined := #t))
      (else
        (format #t "Warning: ~a defined but not found in stdlib!\n"
                sym)))))

(define* section-attributes (total defined))
(define section-ht (make-hashtable equal-hash equal?))
(define (apply-sections)
  (define (proc k e)
    (define (inc! attr defined?)
      (let-with attr (total defined)
        (~ attr 'total := (+ 1 total))
        (when defined?
          (~ attr 'defined := (+ 1 defined)))))
    (define (inc section defined?)
      (let ((e (hashtable-ref section-ht section #f)))
        (cond 
          (e (inc! e defined?))
          (else
            (format #t "Warning: Inconsistent attribute! ~a\n"
                    section)))))
    (let-with e (section-name library)
      (unless (and section-name library)
        (format #t "Warning: Inconsistent definition! ~a\n"
                (list k section-name library)))
      (let ((defined? (memv k defined-symbols)))
        (and section-name
             (inc section-name defined?))
        (and library
             (inc library defined?)))))
  (receive (key ent) (hashtable-entries std-symbol-ht)
    (for-each proc
              (vector->list key)
              (vector->list ent))))

(for-each add-to-ht rep)
(for-each apply-defined defined-symbols)
(for-each (^[e] 
            (hashtable-set! section-ht (car e) (make section-attributes
                                                     (total 0)
                                                     (defined 0))))
          rep)
(apply-sections)

(display (tabular->string
           `(#("Section~sL" "Implemented~dR" "Total~dR")
             ,@(map (^[e] 
                      (let-with (hashtable-ref section-ht (car e) #f)
                        (total defined)
                        (list (car e) defined total)))
                    rep))))
(newline)
