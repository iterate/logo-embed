defmodule Logo.Letters do
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
    {:ok, _ref} = :timer.send_interval(33, :draw_frame)

    {:ok, nil}
  end

  def handle_info(:draw_frame, state) do
    #    [0, 1, 4, 7, 10, 13, 16] |> Enum.map(fn s -> fi(s) end)

    Blinkchain.fill(%Point{x: 0 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 235,
      g: 60,
      b: 66
    })

    Blinkchain.fill(%Point{x: 1 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 247,
      g: 140,
      b: 54
    })

    Blinkchain.fill(%Point{x: 4 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 248,
      g: 234,
      b: 54
    })

    Blinkchain.fill(%Point{x: 7 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 118,
      g: 191,
      b: 69
    })

    Blinkchain.fill(%Point{x: 10 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 138,
      g: 74,
      b: 175
    })

    Blinkchain.fill(%Point{x: 13 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 63,
      g: 84,
      b: 161
    })

    Blinkchain.fill(%Point{x: 16 * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: 62,
      g: 196,
      b: 238
    })

    Blinkchain.render()

    {:noreply, state}
  end

  def randombyte do
    :random.uniform(255)
  end

  def fi(start) do
    Blinkchain.fill(%Point{x: start * 8, y: 0}, 3 * 8, 4 * 8, %Color{
      r: randombyte(),
      g: randombyte(),
      b: randombyte()
    })
  end
end
