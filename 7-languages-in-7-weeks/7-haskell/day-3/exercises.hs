module Exercises where


find keys [] = Nothing
find [k0] ((k,v):assocs) 
    | k0 == k = Just v
    | otherwise = find [k0] assocs
find (k0:morek) ((k,v):assocs)
    | k0 == k = find morek v
    | otherwise = find (k0:morek) assocs


{- TODO -}

