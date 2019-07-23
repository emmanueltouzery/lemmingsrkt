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
(define map (bitmap/file "map.png"))

(struct stanje-igre
  (anim-korak lemming-akcija lemming-x lemming-y) #:transparent)

(define/match* (animiraj (stanje-igre korak akcija lemming-x lemming-y))
  (define lemming
    (crop
          (* 16 (+ (lemming-anim-info-start-x akcija) korak))
          (* 16 (lemming-anim-info-start-y akcija))
          16
          16
          lemming-anim))
  (scale 2
         (place-image/align
          lemming
          lemming-x lemming-y "left" "bottom"
          map)))

(define/match* (naslednji (stanje-igre korak akcija lemming-x lemming-y))
  (define dotaknil-tla (> lemming-y 78))
  (stanje-igre
   (if (>= korak (lemming-anim-info-korake akcija)) 0 (+ 1 korak))
   (if dotaknil-tla hodi pada)
   (if dotaknil-tla (add1 lemming-x) lemming-x)
   (if dotaknil-tla lemming-y (add1 lemming-y))))

(big-bang
  (stanje-igre 0 pada 262 20)
  (on-tick naslednji 0.12)
  (to-draw animiraj))