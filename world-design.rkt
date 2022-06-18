;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname world-design) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; physical constants

(define WIDTH-OF-WORLD 400)
(define HEIGHT-OF-WORLD WIDTH-OF-WORLD)

(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

(define CAR-BODY-WIDTH
  (+ WHEEL-DISTANCE (* WHEEL-RADIUS 5)))

(define CAR-BODY-HEIGHT
  (* CAR-BODY-WIDTH 1/4))

(define X-TREE
  (/ WIDTH-OF-WORLD 1/3))

; graphical constants

(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))

(define SPACE
  (rectangle WHEEL-DISTANCE WHEEL-RADIUS "solid" "white"))

(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))

(define CAR-BODY
  (rectangle CAR-BODY-WIDTH CAR-BODY-HEIGHT "solid" "red"))

(define CAR
  (overlay/offset CAR-BODY
                  0 WHEEL-RADIUS
                  BOTH-WHEELS))

(define BACKGROUND
  (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD))

(define Y-CAR
  (- (image-height BACKGROUND) (/ (image-height CAR) 2)))

(define TREE
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))


; A WorldState is a Number.
; interpretation: the x-coordinate
; of the right-most edge of the car

; WorldState -> Image
; places the image of the car x pixels from
; the left margin of the BACKGROUND image
(define (render x)
  (place-image CAR x Y-CAR
               (place-image TREE (* WIDTH-OF-WORLD 1/3)
                            (- HEIGHT-OF-WORLD
                               (/ (image-height TREE) 2)) BACKGROUND)))

; WorldState -> WorldState
; adds 3 to x to move the car right
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock x)
  (+ x 3))

; WorldState -> WorldState
; checks if x is greater than or equal to the screen width
(check-expect (offScreen? 1) #false)
(check-expect (offScreen? WIDTH-OF-WORLD) #true)
(define (offScreen? x)
  (>= x WIDTH-OF-WORLD))

; WorldState -> WorldState
; launches the program from some initial state 
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]
     [stop-when offScreen?]))