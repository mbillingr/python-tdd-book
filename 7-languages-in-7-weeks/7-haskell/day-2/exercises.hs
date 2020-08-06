module Exercises where

sort [] = []
sort (pivot:rest) = (sort (filter (<= pivot) rest)) ++ [pivot] ++ ((filter (> pivot) . sort) rest)


sort_with pred [] = []
sort_with pred (pivot:rest) = (sort_with pred (filter (\x -> pred x pivot) rest)) 
                           ++ [pivot] 
                           ++ (sort_with pred (filter (\x -> not (pred x pivot)) rest))


ch_to_num '0' = 0
ch_to_num '1' = 1
ch_to_num '2' = 2
ch_to_num '3' = 3
ch_to_num '4' = 4
ch_to_num '5' = 5
ch_to_num '6' = 6
ch_to_num '7' = 7
ch_to_num '8' = 8
ch_to_num '9' = 9

str_to_num = sum . (map (\ (x, y) -> y * 10**x)) . (zip [0..]) . (map ch_to_num) . reverse



every_third x = [x, x+3 ..]
every_fifth y = [y, y+5 ..]

every_eighth x y = zipWith (+) (every_third x) (every_fifth y)



half = (/ 2)

with_newline = (++ ['\n'])

