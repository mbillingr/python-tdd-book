module LazyFib where

lazyFib x y = x:(lazyFib y (x + y))

fiblist = lazyFib 1 2

fib n = head (drop (n - 1) (take n fiblist))

