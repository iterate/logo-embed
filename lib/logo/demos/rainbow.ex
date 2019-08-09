defmodule Rainbow.Worker do
  use GenServer

  alias Blinkchain.Point
  alias Blinkchain.Color

  @colors [
    Color.parse("#9400D3"),
    Color.parse("#4B0082"),
    Color.parse("#0000FF"),
    Color.parse("#00FF00"),
    Color.parse("#FFFF00"),
    Color.parse("#FF7F00"),
    Color.parse("#FF0000")
  ]

  defmodule State do
    defstruct [:timer, :colors]
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    # Send ourselves a message to draw each frame every 33 ms,
    # which will end up being approximately 15 fps.

    state = %State{
      timer: nil,
      colors: @colors
    }

    {:ok, state}
  end

  def handle_info(:draw_frame, state) do
    [c1, c2, c3, c4, c5, c6, c7] = Enum.slice(state.colors, 0..6)
    tail = Enum.slice(state.colors, 1..-1)

    # Shift all pixels to the right
    Blinkchain.copy(%Point{x: 0, y: 0}, %Point{x: 1, y: 0}, 8 * 19 - 1, 8 * 4)

    # Populate the leftmost pixels with new colors
    Blinkchain.set_pixel(%Point{x: 0, y: 0}, c1)
    Blinkchain.set_pixel(%Point{x: 0, y: 1}, c2)
    Blinkchain.set_pixel(%Point{x: 0, y: 2}, c3)
    Blinkchain.set_pixel(%Point{x: 0, y: 3}, c4)
    Blinkchain.set_pixel(%Point{x: 0, y: 4}, c5)
    Blinkchain.set_pixel(%Point{x: 0, y: 5}, c6)
    Blinkchain.set_pixel(%Point{x: 0, y: 6}, c7)

    Blinkchain.set_pixel(%Point{x: 0, y: 7}, c1)
    Blinkchain.set_pixel(%Point{x: 0, y: 8}, c2)
    Blinkchain.set_pixel(%Point{x: 0, y: 9}, c3)
    Blinkchain.set_pixel(%Point{x: 0, y: 10}, c4)
    Blinkchain.set_pixel(%Point{x: 0, y: 11}, c5)
    Blinkchain.set_pixel(%Point{x: 0, y: 12}, c6)
    Blinkchain.set_pixel(%Point{x: 0, y: 13}, c7)

    Blinkchain.set_pixel(%Point{x: 0, y: 14}, c1)
    Blinkchain.set_pixel(%Point{x: 0, y: 15}, c2)
    Blinkchain.set_pixel(%Point{x: 0, y: 16}, c3)
    Blinkchain.set_pixel(%Point{x: 0, y: 17}, c4)
    Blinkchain.set_pixel(%Point{x: 0, y: 18}, c5)
    Blinkchain.set_pixel(%Point{x: 0, y: 19}, c6)
    Blinkchain.set_pixel(%Point{x: 0, y: 20}, c7)

    Blinkchain.set_pixel(%Point{x: 0, y: 21}, c1)
    Blinkchain.set_pixel(%Point{x: 0, y: 22}, c2)
    Blinkchain.set_pixel(%Point{x: 0, y: 23}, c3)
    Blinkchain.set_pixel(%Point{x: 0, y: 24}, c4)
    Blinkchain.set_pixel(%Point{x: 0, y: 25}, c5)
    Blinkchain.set_pixel(%Point{x: 0, y: 26}, c6)
    Blinkchain.set_pixel(%Point{x: 0, y: 27}, c7)

    Blinkchain.set_pixel(%Point{x: 0, y: 28}, c1)
    Blinkchain.set_pixel(%Point{x: 0, y: 29}, c2)
    Blinkchain.set_pixel(%Point{x: 0, y: 30}, c3)
    Blinkchain.set_pixel(%Point{x: 0, y: 31}, c4)

    Blinkchain.render()
    {:noreply, %State{state | colors: tail ++ [c1]}}
  end
end
