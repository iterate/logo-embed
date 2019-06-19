defmodule Rainbow.Worker do
  use GenServer
  alias Blinkchain.Point

  defmodule State do
    defstruct [:timer, :colors]
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    # Send ourselves a message to draw each frame every 33 ms,
    # which will end up being approximately 15 fps.
    {:ok, ref} = :timer.send_interval(100, :draw_frame)

    state = %State{
      timer: ref,
      colors: Rainbow.colors()
    }

    {:ok, state}
  end

  def handle_info(:draw_frame, state) do
    [c1, c2, c3, c4, c5, c6, c7, c8] = Enum.slice(state.colors, 0..7)
    tail = Enum.slice(state.colors, 1..-1)

    # Shift all pixels to the right
    Blinkchain.copy(%Point{x: 0, y: 0}, %Point{x: 1, y: 0}, 7, 8)

    # Populate the five leftmost pixels with new colors
    Blinkchain.set_pixel(%Point{x: 0, y: 0}, c1)
    Blinkchain.set_pixel(%Point{x: 0, y: 1}, c2)
    Blinkchain.set_pixel(%Point{x: 0, y: 2}, c3)
    Blinkchain.set_pixel(%Point{x: 0, y: 3}, c4)
    Blinkchain.set_pixel(%Point{x: 0, y: 4}, c5)
    Blinkchain.set_pixel(%Point{x: 0, y: 5}, c6)
    Blinkchain.set_pixel(%Point{x: 0, y: 6}, c7)
    Blinkchain.set_pixel(%Point{x: 0, y: 7}, c8)

    Blinkchain.render()
    {:noreply, %State{state | colors: tail ++ [c1]}}
  end
end
