
fun eq_int(a: int, b: int) = (a = b)
fun less_than(a: int, b: int) = (a < b)


datatype 'a list
    = Empty
    | Cons of 'a * 'a list

datatype orapl
    = Orange
    | Apple

fun eq_orapl(Orange, Orange) = true
  | eq_orapl(Apple, Apple) = true
  | eq_orapl(one, another) = false

fun subst_int(n, a, Empty)
    = Empty
  | subst_int(n, a, Cons(e, t))
    = if eq_int(a, e)
      then Cons(n, subst_int(n, a, t))
      else Cons(e, subst_int(n, a, t))

fun subst_orapl(n, a, Empty)
    = Empty
  | subst_orapl(n, a, Cons(e, t))
    = if eq_int(a, e)
      then Cons(n, subst_orapl(n, a, t))
      else Cons(e, subst_orapl(n, a, t))

fun subst(relation, n, a, Empty)
    = Empty
  | subst(relation, n, a, Cons(e, t))
    = if relation(a, e)
      then Cons(n, subst(relation, n, a, t))
      else Cons(e, subst(relation, n, a, t))

fun in_range((small, large), x)
    = if less_than(small, x)
      then less_than(x, large)
      else false


fun subst_pred(pred, n, Empty)
    = Empty
  | subst_pred(pred, n, Cons(e, t))
    = if pred(e)
      then Cons(n, subst_pred(pred, n, t))
      else Cons(e, subst_pred(pred, n, t))

fun is_15(n) = eq_int(n, 15)
fun less_than_15(x) = less_than(x, 15)
fun in_range_11_16(x)
    = if less_than(11, x)
      then less_than(x, 16)
      else false

fun in_range_c(small, large)(x)
    = if less_than(small, x)
      then less_than(x, large)
      else false

fun subst_c(pred)(n, Empty)
    = Empty
  | subst_c(pred)(n, Cons(e, t))
    = if pred(e)
      then Cons(n, subst_c(pred)(n, t))
      else Cons(e, subst_c(pred)(n, t))


fun combine(Empty, Empty)
    = Empty
  | combine(Empty, Cons(b, l2))
    = Cons(b, l2)
  | combine(Cons(a, l1), Empty)
    = Cons(a, l1)
  | combine(Cons(a, l1), Cons(b, l2))
    = Cons(a, combine(l1, Cons(b, l2)))

fun combine(Empty, l2)
    = l2
  | combine(Cons(a, l1), l2)
    = Cons(a, combine(l1, l2))

fun combine_c(Empty)(l2)
    = l2
  | combine_c(Cons(a, l1))(l2)
    = Cons(a, combine_c(l1)(l2))
    
fun base(l2) = l2

fun combine_s(Empty)
    = base
  | combine_s(Cons(a, l1))
    = make_cons(a, combine_s(l1))
and
    make_cons(a, f)(l2)
    = Cons(a, f(l2))
    