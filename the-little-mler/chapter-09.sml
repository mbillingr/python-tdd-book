
fun eq_int(a: int, b: int) = (a = b)
fun less_than(a: int, b: int) = (a < b)


datatype 'a list
    = Empty
    | Cons of 'a * 'a list

datatype bacon_or_index
    = Bacon
    | Index of int

fun is_bacon(Bacon) = true
  | is_bacon(Index(n)) = false

exception No_bacon of int

fun where_is(Empty)
    = raise No_bacon(0)
  | where_is(Cons(a_box, rest))
    = if is_bacon(a_box)
        then 1
        else 1 + where_is(rest)

exception Out_of_range

fun list_item(n, Empty)
    = raise Out_of_range
  | list_item(n, Cons(a_box, rest))
    = if eq_int(n, 1)
        then a_box
        else list_item(n - 1, rest)

fun find(n, boxes)
    = (check(n, boxes, list_item(n, boxes))
       handle Out_of_range
       => find(n div 2, boxes))   
and check(n, boxes, Bacon)
    = n
  | check(n, boxes, Index(i))
    = find(i, boxes)

fun path(n, boxes)
    = Cons(n,
        (check(boxes, list_item(n, boxes))
         handle Out_of_range
         => path(n div 2, boxes)))
and check(boxes, Bacon)
    = Empty
  | check(boxes, Index(i))
    = path(i, boxes)

val t = 
  Cons(Index(5),
    Cons(Index(4),
      Cons(Bacon,
        Cons(Index(2),
          Cons(Index(7),
            Empty)))))