#!/usr/bin/env nmosh
(import (rnrs) (emul helper export)
        (mosh test))

(define test-basic '("1bc" 123 0 -1 '() #t #f #\C #\a (1 . 2) #() #("a" 1)))

(test-equal (import (export test-basic)) test-basic)

(test-results)
