;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PEOPLE & GENDER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(Male Tesfaye)
(Female Almaz)

(Male Samson)
(Female Meti)

(Male Getachew)
(Female Mulu)

(Male Eyob)
(Female Betty)

(Male Samuel)
(Female Hana)

(Male Dawit)
(Female Rahel)

(Male Bereket)
(Female Selam)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PARENT RELATIONSHIPS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Grandparents generation
(Parent Tesfaye Samson)
(Parent Almaz Samson)

(Parent Tesfaye Getachew)
(Parent Almaz Getachew)

;; Parents generation
(Parent Samson Eyob)
(Parent Meti Eyob)

(Parent Samson Betty)
(Parent Meti Betty)

(Parent Getachew Samuel)
(Parent Mulu Samuel)

(Parent Getachew Hana)
(Parent Mulu Hana)

;; Next generation
(Parent Eyob Dawit)
(Parent Rahel Dawit)

(Parent Eyob Selam)
(Parent Rahel Selam)

(Parent Samuel Bereket)
(Parent Hana Bereket)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BASIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Get parents
(= (get-parents $y)
   (match &self (Parent $x $y) $x))

; Get children
(= (get-children $x)
   (match &self (Parent $x $y) $y))

; Get father
(= (get-father $x)
   (match &self
     (, (Parent $y $x)
        (Male $y))
     $y))

; Get mother
(= (get-mother $x)
   (match &self
     (, (Parent $y $x)
        (Female $y))
     $y))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SIBLINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Brothers
(= (get-brothers $x)
   (match &self
     (, (Parent $p $x)
        (Parent $p $y)
        (Male $y))
     $y))

; Sisters
(= (get-sisters $x)
   (match &self
     (, (Parent $p $x)
        (Parent $p $y)
        (Female $y))
     $y))

; All siblings
(= (get-siblings $x)
   (match &self
     (, (Parent $p $x)
        (Parent $p $y))
     (unique $y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GRANDPARENTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Grandparents
(= (get-grandparents $x)
   (match &self
     (, (Parent $p $x)
        (Parent $g $p))
     $g))

; Grandfather
(= (get-grandfather $x)
   (match &self
     (, (Parent $p $x)
        (Parent $g $p)
        (Male $g))
     $g))

; Grandmother
(= (get-grandmother $x)
   (match &self
     (, (Parent $p $x)
        (Parent $g $p)
        (Female $g))
     $g))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXTENDED FAMILY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Uncles (brother of parent)
(= (get-uncles $x)
   (match &self
     (, (Parent $p $x)
        (Parent $g $p)
        (Parent $g $u)
        (Male $u))
     $u))

; Aunts (sister of parent)
(= (get-aunts $x)
   (match &self
     (, (Parent $p $x)
        (Parent $g $p)
        (Parent $g $a)
        (Female $a))
     $a))

; Nieces (daughter of sibling)
(= (get-nieces $x)
   (match &self
     (, (Parent $p $x)
        (Parent $p $s)
        (Parent $s $n)
        (Female $n))
     $n))

; Nephews (son of sibling)
(= (get-nephews $x)
   (match &self
     (, (Parent $p $x)
        (Parent $p $s)
        (Parent $s $n)
        (Male $n))
     $n))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECURSIVE NTH PREDECESSORS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Base case: parents
(= (get-nth-predecessors $x 1)
   (get-parents $x))

; Recursive case
(= (get-nth-predecessors $x $n)
   (match &self
     (, (> $n 1)
        (Parent $p $x))
     (get-nth-predecessors $p (- $n 1))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TESTS WITH EXPECTED OUTPUTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ======================
; BASIC TESTS
; ======================

! (get-parents Eyob)
; => [Samson, Meti]

! (get-children Samson)
; => [Eyob, Betty]

! (get-father Eyob)
; => [Samson]

! (get-mother Eyob)
; => [Meti]


; ======================
; SIBLINGS
; ======================

! (get-brothers Betty)
; => [Eyob]

! (get-sisters Eyob)
; => [Betty]

! (get-siblings Eyob)
; => [Eyob, Betty]   ; includes self (ignore)


; ======================
; GRANDPARENTS
; ======================

! (get-grandparents Eyob)
; => [Tesfaye, Almaz]

! (get-grandfather Eyob)
; => [Tesfaye]

! (get-grandmother Eyob)
; => [Almaz]


; ======================
; UNCLES & AUNTS
; ======================

! (get-uncles Dawit)
; => [Getachew]   ; Samson's brother

! (get-aunts Dawit)
; => [Mulu]       ; Getachew's wife not included unless sibling, so limited


; ======================
; NIECES & NEPHEWS
; ======================

! (get-nephews Betty)
; => [Dawit, Selam] ; children of Eyob

! (get-nieces Betty)
; => []


; ======================
; RECURSION TESTS
; ======================
!(predecessors)
! (get-nth-predecessors Dawit 1)
; => [Eyob, Rahel]

! (get-nth-predecessors Dawit 2)
; => [Samson, Meti]

! (get-nth-predecessors Dawit 3)
; => [Tesfaye, Almaz]

;! (get-nth-predecessors Bereket 2)
; => [Getachew, Mulu]

