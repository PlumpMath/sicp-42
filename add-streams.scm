#!/usr/bin/env chicken-scheme
(include "stream-map.scm")

(define (add-streams s1 s2) (stream-map + s1 s2))
