module Fibonacci where

fibonacci :: Integer -> Integer
fibonacci 0 = 1
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n -2)


fib2 :: Integer -> Integer
fib2 n = fib2result (fib2iter (0, 1, n))

fib2result :: (Integer, Integer, Integer) -> Integer
fib2result (x, y, z) = y

fib2iter :: (Integer, Integer, Integer) -> (Integer, Integer, Integer)
fib2iter (x, y, 0) = (x, y, 0)
fib2iter (x, y, i) = fib2iter (y, x + y, i - 1)


fib3 :: Integer -> Integer
fib3 = snd . fib3nth

fib3nth :: Integer -> (Integer, Integer)
fib3nth 1 = (1, 1)
fib3nth n = fib3next (fib3nth (n - 1))

fib3next :: (Integer, Integer) -> (Integer, Integer)
fib3next (x, y) = (y, x + y)
