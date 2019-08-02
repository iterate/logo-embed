defmodule Logo.Squares do
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
    Logger.info("squares!")
    width = 8 * 19 - 1
    height = 8 * 4 - 1

    Logger.info("coordinates!")

    x = :random.uniform(width)
    y = :random.uniform(height)

    Logger.info("dimensions!")

    w = x..(width + 1) |> Enum.random()
    h = y..(height + 1) |> Enum.random()

    Logger.info("fill random!! #{x},#{y}  #{w}x#{h}")

    Blinkchain.fill(%Point{x: x, y: y}, w, h, %Color{
      r: randombyte(),
      g: randombyte(),
      b: randombyte()
    })

    Logger.info("render!")

    Blinkchain.render()

    {:noreply, state}
  end

  def randombyte do
    :random.uniform(255)
  end
end
