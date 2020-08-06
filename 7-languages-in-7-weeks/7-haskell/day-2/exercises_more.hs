module MoreExercises where

my_gcd :: Integer -> Integer -> Integer
my_gcd a 0 = a
my_gcd 0 b = b
my_gcd a b
    | a > b = my_gcd (a - b) b
    | otherwise = my_gcd a (b - a)



primes = pseudo_sieve [2..]
pseudo_sieve (p:xs) = p : pseudo_sieve [x | x <- xs, mod x p > 0]


long_string = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

long_string_words = words long_string
long_string_counts = map length long_string_words


long_string_block "" buffer [] [] n = buffer
long_string_block current_line buffer [] [] n = buffer ++ ['\n'] ++ current_line
long_string_block current_line buffer (w:words) (c:counts) n
    | (length current_line) + c > n = long_string_block w (buffer ++ ['\n'] ++ current_line) words counts n
    | otherwise = long_string_block (current_line ++ " " ++ w) buffer words counts n


result = long_string_block "" "" long_string_words long_string_counts 20

