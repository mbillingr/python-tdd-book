number := Random value(1, 100) round

last_delta := nil
done := false
tries := 0

while(tries < 10 and done not,
  "Guess my number: " print
  guess := File standardInput readLine asNumber

  delta := (guess - number) abs

  if(guess == number,
    "CORRECT" println; done := true,

    if(last_delta != nil,
      if(last_delta > delta, "HOTTER", "COLDER") println
    )
  )

  last_delta := delta;
  tries := tries + 1;
)
