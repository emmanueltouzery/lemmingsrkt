#lang racket

(require 2htdp/image)
(require 2htdp/universe)

(struct lemming-anim-info (start-x start-y korake))

(define stopnicev
  (lemming-anim-info 0 5 16))
(define hodi
  (lemming-anim-info 0 0 9))
(define nimam-kaj
  (lemming-anim-info 9 0 7))
(define pada
  (lemming-anim-info 0 2 3))

(define sedanja-animacija pada) ;; !!!!!!!!!!!!!!!!!

(define lemming-anim (bitmap/file "lemming_anim.png"))

(define (animiraj kateri)
  (scale 7
         (crop
          (* 16 (+ (lemming-anim-info-start-x sedanja-animacija) kateri))
          (* 16 (lemming-anim-info-start-y sedanja-animacija))
          16
          16
          lemming-anim)))

(define (naslednji x)
  (if (>= x (lemming-anim-info-korake sedanja-animacija)) 0 (+ 1 x)))

(big-bang
  0
  (on-tick naslednji 0.12)
  (to-draw animiraj))