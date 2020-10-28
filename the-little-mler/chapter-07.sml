
fun eq_int(a: int, b: int) = (a = b)


fun identity(x) = x

fun true_maker(x) = true

datatype bool_or_int = Hot of bool
                     | Cold of int

fun hot_maker(x) = Hot

fun help(f) = Hot(
    true_maker(
        if true_maker(5)
        then f
        else true_maker))

datatype chain = Link of (int * (int -> chain))

fun ints(n) = Link(n + 1, ints)

fun skips(n) = Link(n + 2, skips)

fun divides_evenly(n, c) = eq_int((n mod c), 0)

fun is_mod_5_or_7(n)
    = if divides_evenly(n, 5)
      then true
      else divides_evenly(n, 7)

fun some_ints(n)
    = if is_mod_5_or_7(n + 1)
      then Link(n + 1, some_ints)
      else some_ints(n + 1)

fun chain_item(n, Link(i, f))
    = if eq_int(n, 1)
      then i
      else chain_item(n - 1, f(i))

fun is_prime(n)
    = has_no_divisors(n, n - 1)
and has_no_divisors(n, c)
    = if eq_int(c, 1)
      then true
      else if divides_evenly(n, c)
           then false
           else has_no_divisors(n, c - 1)

fun primes(n)
    = if is_prime(n + 1)
      then Link(n + 1, primes)
      else primes(n + 1)

fun fibs(n)(m)
    = Link(n + m, fibs(m))
