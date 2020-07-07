
List2D := Object clone
List2D data := nil

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
  self data at(y) atPut(x, value);
  self
)

List2D get := method(x, y, value,
  self data at(y) at(x)
)
