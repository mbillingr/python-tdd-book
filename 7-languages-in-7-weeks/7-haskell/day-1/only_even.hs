module Even where

only_even :: [Integer] -> [Integer]
only_even [] = []
only_even (h:t) = if even h then h:only_even t else only_even t

only_even2 :: [Integer] -> [Integer]
only_even2 l = [x | x <- l, even x]

