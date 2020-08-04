module Exercises where

rev l = rev_iter l []

rev_iter [] out = out
rev_iter (h:t) out = rev_iter t (h:out)


colors = ["black", "white", "blue", "yellow", "red"]

two_colors = [(a, b) | a <- colors, b <- colors, a < b]


multiplications = [(a, b, a*b) | a <- [1..12], b <- [1..12]]



is_coloring_valid (tennessee, mississippi, alabama, georgia, florida) = 
    (tennessee /= mississippi) &&
    (tennessee /= alabama) &&
    (tennessee /= georgia) &&
    (mississippi /= alabama) &&
    (alabama /= georgia) &&
    (alabama /= florida) &&
    (georgia /= florida)


colorings = [(a, b, c, d, e) 
    | a <- colors, 
      b <- colors, 
      c <- colors, 
      d <- colors, 
      e <- colors,
      is_coloring_valid(a, b, c, d, e)]

