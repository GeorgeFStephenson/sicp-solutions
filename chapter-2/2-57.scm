; prerequisites

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

; solution

(define (augend s) 
  (define (describe-augend a2)
    (if (null? (cdr a2)) 
        (car a2)
        (make-sum (car a2) (describe-augend (cdr a2)))))
  (describe-augend (cddr s)))

(define (multiplicand p)
  (define (describe-multiplicand m2)
    (if (null? (cdr m2)) 
        (car m2)
        (make-product (car m2) (describe-multiplicand (cdr m2)))))
  (describe-multiplicand (cddr p)))

(deriv '(* x y (+ x 3)) 'x)
;Value: (+ (* x y) (* y (+ x 3)))

; This exercise example only gives three terms, which means a naive implementation
; that checks if multiplicand is one term or two terms would work.
; But the right solution requires recursion in multiplicand, it can be any number of terms.