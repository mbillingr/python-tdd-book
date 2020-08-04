module Lists where

len [] = 0
len (h:t) = 1 + len t

elsum [] = 0
elsum (h:t) = h + elsum t

