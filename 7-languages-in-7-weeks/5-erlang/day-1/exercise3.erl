-module(exercise3).
-export([show/1]).

show(success) -> io:format("success~n");
show({error, Message}) -> io:format("error: ~s~n", [Message]).

