
fib := method(n,
  a := 1
  b := 1
  for(i, 1, n,
    tmp := a + b;
    a = b;
    b = tmp;
  )
  a
)

fib(30) print
