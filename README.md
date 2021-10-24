# DList

Dlist is an implementation of a doubly-linked list based on the PicoLisp examples from [RosettaCode](https://www.rosettacode.org/wiki/Doubly-linked_list/Definition). It includes an intrusive and non-intrusive version.

## Data

    DList (Header)

            +------------> start link
            |
          +--+--+-----+
          |  |  |  ---+---> end link
          +-----+-----+

    Link

          +-----+-----+     +-----+-----+
          | Val |  ---+---> |  |  |  ---+---> next link
          +-----+-----+     +--+--+-----+
                              |
                prev link <---+

## Code

    # use namespaces 'dlistint or 'dlistext
    (symbols 'dlist 'pico)
    
    # TODO
