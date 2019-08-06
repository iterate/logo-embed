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
    GenServer.cast(__MODULE__, {:set_pixel, {point, color}})
  end

  @spec render :: :ok
  def render() do
    GenServer.cast(__MODULE__, :render)
  end

  @spec fill(Color.t()) :: :ok
  def fill(color) do
    GenServer.cast(__MODULE__, {:fill, color})
  end

  # casts

  def handle_cast({:set_pixel, {point, color}}, state) do
    {buffer, dirty} =
      case(Map.has_key?(state.buffer, point)) do
        true ->
          {state.buffer |> Map.put(point, color), true}

        false ->
          {state.buffer, state.dirty}
      end

    {:noreply, %State{buffer: buffer, dirty: dirty}}
  end

  def handle_cast(:render, state) do
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

    {:noreply, state}
  end

  def handle_cast({:fill, color}, state) do
    buffer =
      state.buffer
      |> Enum.reduce(Map.new(), fn {point, _color}, acc ->
        Map.put(acc, point, color)
      end)

    {:noreply, %State{buffer: buffer, dirty: true}}
  end
end
