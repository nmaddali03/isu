// problem 1

(
    define isRightAngled (
        lambda (H B L) (
            if (= (* H H) (+ (* B B) (* L L)))
                #t
                #f
        )
    )
)
// problem 2
(
    define lucas (
        lambda (n) (
            if (< n 3)
                (if (< n 1)
                    #f
                    (- 3 n))
                (+ (lucas (- n 1)) (lucas (- n 2)))
        )
    )
)
// problem 3b
(
    define freq (
        lambda (lst elem) (
            if (null? lst)
                0
                (
                    if (= (car lst) elem)
                    (+ 1 (freq (cdr lst) elem))
                    (freq (cdr lst) elem)
                )
        )
    )
)

(
    define append (
        lambda (lst1 lst2) (
            if (null? lst1) lst2
                (if (null? lst2) lst1
                (cons (car lst1) (append (cdr lst1) lst2)))
        )
    )
)
// problem 3b
(
    define luc (
        lambda (n) (
            if (< n 1)
                #f
                (
                    if (= n 1)
                    (list (lucas 1))
                    (append (luc (- n 1)) (list (lucas n)))
                )
        )
    )
)
// problem 4a
(
    define address (
        list
        (cons "City" "Ames")
        (cons "State" "Iowa")
        (cons "Country" "USA")
    )
)
// problem 4b
(
    define get-address (
        lambda (address) (
            if (null? address)
                (list)
                (append (list (cdr (car address))) (get-address (cdr address)))
        )
    )
)
// problem 4c
(
    define get-state (
        lambda (address) (
            list "From-State" (cdr (car (cdr address)))
        )
    )
)

(
    define length (
        lambda (lst) (
            if (null? lst)
                0
                (+ 1 (length (cdr lst)))
        )
    )
)
// problem 4d
(
    define pairup (
        lambda (val key) (
            if (= (length val) (length key))
                (
                    if (= 1 (length val))
                        (list (car val) (car key))
                        (cons (cons (car val) (car key)) (pairup (cdr val) (cdr key)))
                )
                (list)
        )
    )
)

(define inc (lambda (x) (+ x 1)))
(define inc2 (lambda (x) (+ x 2)))
(define test2 (lambda (x) (< x 2)))
(define test10 (lambda (x) (< x 10)))
(define test25 (lambda (x) (< x 25)))
(define test42 (lambda (x) (< x 42)))
(define body (lambda (x) x))
(define body-add (lambda (x) (+ x 42)))
(define body-mul (lambda (x) (* x 1)))

(
    define last (
        lambda (counter condition increment) (
            if (condition (increment counter))
                (last (increment counter) condition increment)
                counter
        )
    )
)
// problem 5
(
    define for-loop (
        lambda (counter condition increment) (
            if (condition counter)
                (lambda (loop-body) (
                    loop-body (
                        last counter condition increment
                    )
                ))
                (lambda (loop-body) #f)
        )
    )
)

(
    define pair (
        lambda (fst snd) (
            lambda (op) (
                if op fst snd
            )
        )
    )
)

(
    define tuple (
        lambda (fst snd trd) (
            lambda (op) (
                if op
                    fst
                    (pair snd trd)
            )
        )
    )
)

(
    define first (
        lambda (p) (
            p #t
        )
    )
)

(
    define second (
        lambda (p) (
            (p #f) #t
        )
    )
)

(
    define third (
        lambda (p) (
            (p #f) #f
        )
    )
)

(
    define mod (
        lambda (x y) (
            if (< x y)
                x
                (mod (- x y) y)
        )
    )
)

(
    define gcdp (
        lambda (x y) (
            if (= x 0)
                y
                (
                    if (< y x)
                        (gcdp y x)
                        (gcdp (mod y x) x)
                    )
        )
    )
)
// problem 6
(
    define gcd (
        lambda (x) (
            gcdp (gcdp (first x) (second x)) (third x)
        )
    )
)
// problem 7a
(
    define list1 (
        list
        (pair 1 3)
        (pair 4 2)
        (pair 5 6)
    )
)

(
    define list2 (
        list
        (pair 2 6)
        (pair 4 2)
        (pair 1 3)
    )
)
// problem 7b
(
    define process-lists (
        lambda (op lst1 lst2) (
            if (= (length lst1) (length lst2))
                (if (= 1 (length lst1))
                    (op (car lst1) (car lst2))
                    (list (op (car lst1) (car lst2)) (process-lists op (cdr lst1) (cdr lst2)))
                )
                (list)
        )
    )
)

(define snd (lambda (x) (x #f)))
// problem 7c
(
    define add (
        lambda (a b) (
            list
            (+ (first a) (first b))
            (+ (snd a) (snd b))
        )
    )
)

(
    define subtract (
        lambda (a b) (
            list
            (- (first a) (first b))
            (- (snd a) (snd b))
        )
    )
)

(
    define in (
        lambda (val lst) (
            if (null? lst)
                #f
                (if (= val (car lst))
                    #t
                    (in val (cdr lst))
                )
        )
    )
)

(
    define set (
        lambda (s val) (
            if (null? s)
                (list val)
                (if (in val s)
                    s
                    (list val s)
                )
        )
    )
)

(
    define makeset (
        lambda (s lst) (
            if (null? lst)
                s
                (if (in (car lst) s)
                    (makeset s (cdr lst))
                    (makeset (list (car lst) s) (cdr lst))
                )
        )
    )
)

(
    define intoset (
        lambda (lst) (
            makeset (list) lst
        )
    )
)

(
    define lfp (
        lambda (p) (
            list (p #t) (p #f)
        )
    )
)

(
    define zip (
        lambda (a b) (
            pairup (lfp a) (lfp b)
        )
    )
)

(
    define or (
        lambda (a b) (
            if a
                #t
                (if b #t #f)
        )
    )
)

(
    define and (
        lambda (a b) (
            if a
                (if b #t #f)
                #f
        )
    )
)

(
    define filter (
        lambda (op lst) (
            if (null? lst)
                (list)
                (if (op (car lst))
                    (cons (car lst) (filter op (cdr lst)))
                    (filter op (cdr lst))
                )
        )
    )
)

(
    define common (
        lambda (a b) (
            filter (lambda(x) (and (in x (lfp a)) (in x (lfp b)))) (append (lfp a) (lfp b))
        )
    )
)
// problem 7d
(
    define curried-process-lists (
        lambda (op) (
            lambda (lst1) (
                lambda (lst2) (
                    process-lists op lst1 lst2
                )
            )
        )
    )
)