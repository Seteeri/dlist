#{

  DList (Header)

           +------------> start link
           |
        +--+--+-----+
        |  |  |  ---+---> end link
        +-----+-----+

  Link

        +-----+-----+     +-----+-----+
        | Val |  ---+---> |  |  |  ---+---> forward link
        +-----+-----+     +--+--+-----+
                             |
               back link <---+

  Based on the structure, using primitive cons operations,
  the following operators can be defined:

  (car  Ln) = get val
  (set  Ln) = set val
  (cadr Ln) = get back link
  (cddr Ln) = get fwd link
  (set (cdr Ln) any) = set back link
  (con (cdr Ln) any) = set fwd link
  (caddr Ln) = get fwd link val
  (caadr Ln) = get back link val


  TODO:

    (nth Dlst Cnt)   = link @ Cnt
    (get Dlst Cnt)   = (car (nth Dlst Cnt)) [need nth]
    (ins Dlst Cnt V) = insert value at Cnt [need 'get]
    (rm/pop-v Dlst V)      = remove value (1st inst)
    (length Dlst)    = ...

    * insert fns types and positions:
      L L F/B
      L V F/B
      V L F/B
      V V F/B

    * no postfix = val
    * "-l" postfix = link
    * exception: when existing pico sym

}#

(symbols 'dlistint 'pico)

(local)
(back front push-f push-b
 pop-f pop-b
 gv gv-b gv-f gl-b gl-f
 sv sl-b sl-f
 make
 ins-ln ins-b ins-f ins-h ins-t
 pop-l
 psp-f psp-b
 mv-f mv-b
 ml-f ml-b
 tst)

# Deque operations (syntactic sugar)
# Follow C++ naming conventions for clarity...

(def 'back  car)
(def 'front cdr)

(def 'push-f ins-h)
(def 'push-b ins-t)

(de pop-f (Dl) (gv (pop-l Dl (front Dl))))
(de pop-b (Dl) (gv (pop-l Dl (back Dl))))

# Getters Link/Val (syntactic sugar)

(def 'gv car)   # Get link val
(def 'gv-b caadr) # Get back link val
(def 'gv-f caddr) # Get fwd link val
(def 'gl-b cadr)  # Get back link
(def 'gl-f cddr)  # Get fwd link

# Setters Link/Val (syntactic sugar)

(def 'sv set) # Set link val
(de  sl-b (Ln V) (set (cdr Ln) V)) # Set back link
(de  sl-f (Ln V) (con (cdr Ln) V)) # Set fwd link
#(de  sv-b (Ln V) (set (cadr Ln) V)) # Set back link val
#(de  sv-f (Ln V) (set (cddr Ln) V)) # Set fwd link val

(de make (V B F)
  (cons V (cons B F)))

(de ins-ln (Dl P N V)
  # Insert a new link with value (V)
  # after existing link BEFORE if not nil and
  # before existing link AFTER if not nil
  (let Ln-New (cons V (cons P N))
    (if P
        (sl-f P Ln-New)  # set fwd of A/link
        (set Dl Ln-New)) # set head of Dl
    (if N
        (sl-b N Ln-New)  # set back of B/link
        (con Dl Ln-New)) # set tail of Dl
    Ln-New))


# Insert value (V) before existing link (Ln)
(de ins-b (Dl Ln V)
  (ins-ln Dl (gl-b Ln) Ln V))

# Insert value (V) after existing link (Ln)
(de ins-f (Dl Ln V)
  (ins-ln Dl Ln (gl-f Ln) V))

# Insert value (V) at head of Dlst (Dl)
(de ins-h (Dl V)
  (ins-ln Dl NIL (car Dl) V))

# Insert value (V) at tail of Dlst (Dl)
(de ins-t (Dl V)
  (ins-ln Dl (cdr Dl) NIL V))

# Pop link
(de pop-l (Dl Ln)
  # Remove link (Ln) from Dlst (Dl) and
  # return its content
  (let (P (gl-b Ln)
        N (gl-f Ln))
    (if P
        (sl-f P N)
        (set Dl N))
    (if N
        (sl-b N P)
        (con Dl P))))

# printsp* values

(de psp-f (Dl)
  # Printsp the values of Dlst (Dl) as a list
  (let Ln (car Dl)
    (while Ln
      (printsp (gv Ln))
      (setq Ln (gl-f Ln))))
  (prinl))

(de psp-b (Dl)
  # Printsp the values of Dlst (Dl) as a list
  (let Ln (cdr Dl)
    (while Ln
      (printsp (gv Ln))
      (setq Ln (gl-b Ln))))
  (prinl))

# make list of values

(de mv-f (Dl)
  # Return the values of Dlst (Dl) as a list
  (let Ln (car Dl)
    (make
      (while Ln
        (link (gv Ln))
        (setq Ln (gl-f Ln))))))

(de mv-b (Dl)
  # Return the values of Dlst (Dl) as a list
  (let Ln (cdr Dl)
    (make
      (while Ln
        (link (gv Ln))
        (setq Ln (gl-b Ln))))))

# list of ptrs to links
# use 'adr to dereference

(de ml-f (Dl)
  # Return the links backwards of Dlst (Dl) as a list
  (let Ln (car Dl)
    (make
      (while Ln
        (link (adr Ln))
        (setq Ln (gl-f Ln))))))

(de ml-b (Dl)
  # Return the links forwards of Dlst (Dl) as a list
  (let Ln (cdr Dl)
    (make
      (while Ln
        (link (adr Ln))
        (setq Ln (gl-b Ln))))))

(de tst ()
  (prinl "START TEST")
  (let Dl (cons)
    (prinl "ins-h") (ins-h Dl 1)
    (prinl "ins-t") (ins-t Dl 2)
    (prinl "ins-f") (ins-f Dl (car Dl) 3)
    (prinl "ins-b") (ins-b Dl (cdr Dl) 4)
    (prinl "psp-b") (psp-b Dl)
    (prinl "psp-f") (psp-f Dl)
    (prinl "mv-b")  (println (mv-b Dl))
    (prinl "mv-f")  (println (mv-f Dl))
    (prinl "ml-b")  (println (ml-b Dl))
    (prinl "ml-f")  (println (ml-f Dl))
    (psp-f Dl)
    (prinl "pop-f") (pop-f Dl (adr (cadr (ml-f Dl)))) (psp-f Dl)
    (prinl "pop-b") (pop-b Dl (adr (cadr (ml-f Dl)))) (psp-f Dl)
  "TEST DONE"))
