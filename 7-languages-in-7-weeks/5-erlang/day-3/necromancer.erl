-module(necromancer).
-export([loop/0]).

% send a number between 1 and 6
loop() ->
  process_flag(trap_exit, true),
  receive
    new ->
      io:format("Creating and monitoring process.~n"),
      register(revolver, spawn_link(fun roulette:loop/0)),
      loop();
    {'EXIT', From, Reason} ->
      io:format("The shooter ~p died with reason ~p.", [From, Reason]),
      io:format("Raising...~n"),
      self() ! new,
      loop()
  end.
