defmodule Pixel do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start() do
    {:ok, _} = Nerves.Neopixel.start_link(pin: 18, count: 192)
    Pixel.run()
  end

  def render() do
    GenServer.cast(__MODULE__, {:render, []})
  end

  # CALLBACKS

  @impl true
  def init(args) do
    schedule_work()
    {:ok, args}
  end

  @impl true
  def handle_cast({:render, _}, state) do
    Pixel.run()
    {:noreply, state}
  end

  @impl true
  def handle_info(:work, state) do
    __MODULE__.render()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 80)
  end

  # CRAZY BANANAS

  def run() do
    Nerves.Neopixel.render(0, {40, logocolors()})
  end

  def logocolors() do
    [logocolor()]
    |> List.flatten()
  end

  def logocolor() do
    case HelloNetwork.connected?() do
      false -> {255, 0, 0}
      true -> get_internet_color()
    end
  end

  def get_internet_color() do
    body = HTTPotion.get("https://logo.app.iterate.no/logo").body
    payload = Poison.Parser.parse!(body, %{})
    logo = payload["logo"]
    i = logo |> List.first()

    i
    |> Enum.reverse()
    |> Enum.map(&block2color/1)
  end

  def block2color(block) do
    block
    |> rotate_block()
    |> Enum.map(&hex2color/1)
  end

  def rotate_block(block) do
    matrix = Enum.chunk_every(block, 8, 8, :discard)

    for n <- 0..63, do: get_x_y(n, matrix)
  end

  def get_x_y(n, matrix) do
    x = Integer.floor_div(n, 8)
    y = 7 - (n - 8 * x)

    matrix
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def hex2color(code) do
    red = code |> String.slice(1, 2) |> String.to_integer(16)
    green = code |> String.slice(3, 2) |> String.to_integer(16)
    blue = code |> String.slice(5, 2) |> String.to_integer(16)
    {red, green, blue}
  end
end
