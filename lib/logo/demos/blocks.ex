defmodule Logo.Blocks do
  use GenServer

  require Logger

  alias Blinkchain.Point
  alias Blinkchain.Color

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    # Send ourselves a message to draw each frame every 33 ms,
    # which will end up being approximately 15 fps.
    {:ok, ref} = :timer.send_interval(33, :draw_frame)

    {:ok, ref}
  end

  def handle_info(:draw_frame, state) do
    width = 19 - 1
    height = 4 - 1

    x = :random.uniform(width)
    y = :random.uniform(height)

    Logo.Debug.all_black()

    Blinkchain.fill(%Point{x: x * 8, y: y * 8}, 8, 8, %Color{
      r: 255,
      g: 255,
      b: 255
    })

    Blinkchain.render()

    {:noreply, state}
  end

  def randombyte do
    :random.uniform(255)
  end
end
