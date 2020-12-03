defmodule Rectangle do
  def area({w}), do: Rectangle.area({w, w})

  def area({h, w}), do: h * w

  def perimeter({w}), do: Rectangle.perimeter({w, w})

  def perimeter({h, w}) do
    2 * (h + w)
  end
end

