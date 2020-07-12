:- use_module(library(clpfd)).

eight_queens(Queens) :-
    maplist(pos, [1, 2, 3, 4, 5, 6, 7, 8], Queens, XY),
    maplist(diagonal1, XY, D1),
    all_different(D1),
    maplist(diagonal2, XY, D2),
    all_different(D2),
    permute(Queens, [1, 2, 3, 4, 5, 6, 7, 8]).

pos(Row, Col, (Row, Col)).

diagonal1((Row, Col), Dia) :- Dia #= Row - Col.
diagonal2((Row, Col), Dia) :- Dia #= Row + Col.

permute([], []).
permute([X|Rest], L) :-
    permute(Rest, L1),
    select(X, L, L1).
