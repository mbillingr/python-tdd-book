USING: io kernel math math.parser random ;
IN: examples.numberguess

: guess-number ( n -- n )
  dup
  "Guess my number: " print
  readln string>number

  [ = ] [ < ] [ > ] 2tri

  [ [ "Winner" print f ] [ t ] if ]
  [ [ "Lower" print ] when ]
  [ [ "Higher" print ] when ]
  tri*

  [ guess-number ] when
;

: numberguess ( -- )
  100 random
  guess-number
  drop
;

MAIN: numberguess
