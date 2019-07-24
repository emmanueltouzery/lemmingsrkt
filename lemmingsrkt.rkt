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
(define nivo (bitmap/file "map.png"))
(define barve-nivoja (list->vector (image->color-list nivo)))

(define (prozorno? x y)
  (equal? (color 255 255 255 0)
          (vector-ref barve-nivoja (+ x (* (image-width nivo) y)))))

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
          lemming-x lemming-y "center" "bottom"
          nivo)))

(define/match* (naslednji (stanje-igre korak akcija lemming-x lemming-y))
  (define dotaknil-tla (not (prozorno? lemming-x lemming-y)))
  (define nova-akcija (if dotaknil-tla hodi pada))
  (stanje-igre
   (if (>= korak (lemming-anim-info-korake nova-akcija)) 0 (+ 1 korak))
   nova-akcija
   (if dotaknil-tla (add1 lemming-x) lemming-x)
   (if dotaknil-tla lemming-y (add1 lemming-y))))

(big-bang
  (stanje-igre 0 pada 211 20)
  (on-tick naslednji 0.12)
  (to-draw animiraj))
