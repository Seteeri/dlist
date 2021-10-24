#{

  header structure, containing one pointer to the start and one to the end of the list:
  
           +------------> start
           |
        +--+--+-----+
        |  |  |  ---+---> end
        +-----+-----+

  element structure, two cells per doubly-linked list element:

        +-----+-----+     +-----+-----+
        | Val |  ---+---> |  |  |  ---+---> next
        +-----+-----+     +--+--+-----+
                             |
                    prev <---+

  'cddr' can be used to access the next, and 'cadr' to access the previous element

}#

(symbols 'dlistext 'pico)

# element
(local) (next-el prev-el)
(def 'next-el cddr)
(def 'prev-el cadr)

# dlist
(local) (head-el tail-el head-val tail-val)
(def 'head-el car) # -> element
(def 'tail-el cdr) # -> element
(def 'head-val caar) # -> value of head element
(def 'tail-val cadr) # -> value of tail element

(local) (make)
(de make (List)
   (let Prev NIL
      (let L
         (pico~make
            (while List
               (setq Prev (chain (list (pop 'List) Prev))) ) )
         (cons L Prev) ) ) )

(local) (make@)
(de make@ @
   (let Prev NIL
      (let L
         (pico~make
            (while (args)
               (setq Prev (chain (list (pico~next) Prev))) ) )
         (cons L Prev) ) ) )

# push tail
(local) (push-right)
(de push-right (X DLst)
   (let L (cdr DLst)
      (con DLst (cons X L NIL))
      (if L
         (con (cdr L) (cdr DLst))
         (set DLst (cdr DLst)) ) ) )
 
# push head
(local) (push-left)
(de push-left (X DLst)
   (let L (car DLst)                  # Get current data list
      (set DLst (cons X NIL L))       # Prepend two new cons pairs
      (if L                           # Unless DLst was empty
         (set (cdr L) (car DLst))     # set new 'prev' link
         (con DLst (car DLst)) ) ) )  # otherwise set 'end' link

# pop head
(local) (pop-left)
(de pop-left (DLst)
  (let (A (car DLst)
        N (cddr A))
    (set DLst N) # set dlist head to next (new head)
    (if (cddr N) # if next has cdr, keep it
        (set (cdr N)) # set prev of next to NIL
        (con N)) # remove cdr
    # if one element, head = tail, set tail
    (unless (cdr A) (con DLst N))
    # return val of old head
    (car A)))

# pop tail
(local) (pop-right)
(de pop-right (DLst)
  (let (B (cdr DLst)
        P (cadr B))
    (con DLst P) # set dlist tail to prev (new tail)
    (if (cadr P) # if prev has cdr, keep it
        (con (cdr P)) # set next of prev to NIL
        (con P)) # remove cdr
    # if one element, head = tail, set head
    (unless (car B) (set DLst P))
    # return val of old tail
    (car B)))

# Insert an element X at position Pos
(local) (insert)
(de insert (X Pos DLst)
   (let (Lst (nth (car DLst) (dec (* 2 Pos)))  
         New (cons X (cadr Lst) Lst))
      (if (cadr Lst)
         (con (cdr @) New)
         (set DLst New) )
      (if (cdr Lst)
         (set @ New)
         (con DLst New) ) ) )

(local) (loop loop-rev)
(de loop (DLst Fn) (for (L (car DLst) L (cddr L)) (Fn (car L))))
(de loop-rev (DLst Fn) (for (L (cdr DLst) L (cadr L)) (Fn (car L))))

(local) (len)
(de len (DLst) (let Cnt 0 (loop DLst '((X) (inc 'Cnt)))))

(local) (print print-rev)
(de print (DLst) (loop DLst 'printsp))
(de print-rev (DLst) (loop-rev DLst 'printsp))

# return list
(local) (list list-rev)
(de list (DLst) (pico~make (loop DLst 'link)))
(de list-rev (DLst) (pico~make (loop-rev DLst 'link)))

# nth, head, tail
