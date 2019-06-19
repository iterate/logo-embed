defmodule Rainbow do
  alias Blinkchain.Color

  @colors [
    Color.parse("#FFFFFF"),
    Color.parse("#FF0000"),
    Color.parse("#00FF00"),
    Color.parse("#0000FF"),
    Color.parse("#FFFFFF"),
    Color.parse("#FF0000"),
    Color.parse("#00FF00"),
    Color.parse("#0000FF")
  ]

  def colors, do: @colors
end
