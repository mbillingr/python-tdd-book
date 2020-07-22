-module(exercise1).
-export([assoc/2]).

assoc(_, []) -> false;
assoc(K, [{K, V} | _]) -> {K, V};
assoc(K, [_ | Rest]) -> assoc(K, Rest).

