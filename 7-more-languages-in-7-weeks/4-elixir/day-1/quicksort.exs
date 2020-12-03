defmodule QuickSort do
  def sort([]), do: []
  def sort([head|tail]) do
    sort( for(x <- tail, x <= head, do: x) ) ++ [head] ++ sort( for(x <- tail, x > head, do: x) )
  end
end

IO.inspect QuickSort.sort([7, 5, 3, 1, 9, 0, 2, 4, 6, 8])

