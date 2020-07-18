-module(exercise2).
-export([count_to_ten/0]).

suppress(_) -> ok.

count(0) -> ok;
count(N) -> suppress({count(N-1), io:format("~.B~n", [N])}).

count_to_ten() -> count(10).
