
List2D := Object clone
List2D data := nil
List2D transposed := false

dim := method(x, y,
  matrix := List2D clone;
  matrix data := list();
  for(i, 1, y,
    row := list();
    for(j, 1, x,
      row append(nil)
    );
    matrix data append(row)
  );
  matrix
)

List2D set := method(x, y, value,
  if(self transposed,
    self data at(x) atPut(y, value),
    self data at(y) atPut(x, value)
  );
  self
)

List2D get := method(x, y, value,
  if(self transposed,
    self data at(x) at(y),
    self data at(y) at(x)
  )
)

List2D transpose := method(
  matrix := self clone;
  matrix transposed := self transposed not;
  matrix
)


mat := dim(3, 2)
mat set(0, 0, 10)
mat set(1, 0, 20)
mat set(2, 0, 30)
mat set(0, 1, 40)
mat set(1, 1, 50)
mat set(2, 1, 60)

tmat := mat transpose
