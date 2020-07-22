-module(roulette).
-export([loop/0]).

% send a number between 1 and 6
loop() ->
  receive
    3 -> io:format("bang.~n"), exit({roulette, die, at, erlang:time()});
    _ -> io:format("click~n"), loop()
  end.
