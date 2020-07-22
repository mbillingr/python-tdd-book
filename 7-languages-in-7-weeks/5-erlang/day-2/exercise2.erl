-module(exercise2).
-export([total/1]).

total(List) -> [{Item, N * Price} || {Item, N, Price} <- List].

