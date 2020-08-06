module MyRange where

my_range start step = start : (my_range (start + step) step)

