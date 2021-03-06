defmodule Logo.Skilt do
  use GenServer

  alias Blinkchain.Color
  alias Blinkchain.Point

  defmodule State do
    defstruct [:buffer, :dirty]
  end

  @width 8 * 19
  @height 8 * 4

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec init(any) :: {:ok, Logo.Skilt.LiveLogo.State.t()}
  def init(_opts) do
    buffer =
      for x <- 0..(@width - 1), y <- 0..(@height - 1) do
        {%Point{x: x, y: y}, %Color{r: 0, g: 0, b: 0}}
      end
      |> Enum.reduce(
        Map.new(),
        fn {point, color}, acc -> Map.put(acc, point, color) end
      )

    state = %State{buffer: buffer, dirty: true}
    {:ok, state}
  end

  @spec set_pixel(Point.t(), Color.t()) :: :ok
  def set_pixel(point, color) do
    GenServer.call(__MODULE__, {:set_pixel, {point, color}})
  end

  @spec get_pixel(Point.t()) :: Color.t()
  def get_pixel(point) do
    GenServer.call(__MODULE__, {:get_pixel, point})
  end

  @spec render :: :ok
  def render() do
    GenServer.call(__MODULE__, :render)
  end

  @spec fill(Color.t()) :: :ok
  def fill(color) do
    GenServer.call(__MODULE__, {:fill, color})
  end

  # casts

  def handle_call({:set_pixel, {point, color}}, _from, state) do
    {buffer, dirty} =
      case(Map.get(state.buffer, point)) do
        ^color ->
          {state.buffer, state.dirty}

        nil ->
          {state.buffer, state.dirty}

        _different_color ->
          {state.buffer |> Map.put(point, color), true}
      end

    {:reply, nil, %State{buffer: buffer, dirty: dirty}}
  end

  def handle_call(:render, _from, state) do
    state =
      case state.dirty do
        true ->
          state.buffer
          |> Enum.each(fn {point, color} ->
            Blinkchain.set_pixel(point, color)
          end)

          Blinkchain.render()
          %State{buffer: state.buffer, dirty: false}

        false ->
          state
      end

    {:reply, nil, state}
  end

  def handle_call({:fill, color}, _from, state) do
    buffer =
      state.buffer
      |> Enum.reduce(Map.new(), fn {point, _color}, acc ->
        Map.put(acc, point, color)
      end)

    {:reply, nil, %State{buffer: buffer, dirty: true}}
  end

  def handle_call({:get_pixel, point}, _from, state) do
    pixel = state.buffer |> Map.get(point)
    {:reply, pixel, state}
  end
end
