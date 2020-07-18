-module(exercise1).
-export([count_words/1]).

count_words("") -> 0;
count_words(" ") -> 0;
count_words([X]) -> 1;
count_words([32 | Rest]) -> count_words(Rest);
count_words([X, 32 | Rest]) -> 1 + count_words(Rest);
count_words([X | Rest]) -> count_words(Rest).

