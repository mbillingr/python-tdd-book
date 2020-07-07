List myAverage := method(
  if(self isEmpty, 0, self sum / self size)
)

list(1, 2, 3, 4) myAverage println

list() myAverage println

list(1, 2, 3, 4) myAverage println
