-module(translate_service).
-export([loop/0, translate/2]).

translate(To, Word) ->
	To ! {self(), Word},
	receive
		Translation -> Translation
	end.

loop() ->
	receive
		{Pid, "casa"} -> 
			Pid ! "house",
			loop();
		{Pid, "blanca"} ->
			Pid ! "white",
			loop();
		{Pid, _} ->
			Pid ! "I don't understand.",
			loop()
	end.

