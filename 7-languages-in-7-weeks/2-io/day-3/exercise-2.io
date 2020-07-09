
squareBrackets := method(
  r := List clone
  call message arguments foreach(arg,
    r append(arg)
  )
  r
)

[1, "TWO", 3] println
