#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require match-plus)

(struct lemming-anim-info (start-x start-y korake) #:transparent)

(define stopnicev
  (lemming-anim-info 0 5 16))
(define hodi
  (lemming-anim-info 0 0 9))
(define nimam-kaj
  (lemming-anim-info 9 0 7))
(define pada
  (lemming-anim-info 0 2 3))

(define lemming-anim (bitmap/file "lemming_anim.png"))

(struct stanje-igre
  (anim-korak lemming-akcija) #:transparent)

(define/match* (animiraj (stanje-igre korak akcija))
  (scale 7
         (crop
          (* 16 (+ (lemming-anim-info-start-x akcija) korak))
          (* 16 (lemming-anim-info-start-y akcija))
          16
          16
          lemming-anim)))

(define/match* (naslednji (stanje-igre korak akcija))
  (stanje-igre
   (if (>= korak (lemming-anim-info-korake akcija)) 0 (+ 1 korak))
   akcija))

(big-bang
  (stanje-igre 0 pada)
  (on-tick naslednji 0.12)
  (to-draw animiraj))