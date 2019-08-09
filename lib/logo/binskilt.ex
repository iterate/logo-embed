defmodule Logo.Binskilt do
  use GenServer

  require Logger

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
    buffer = <<0, 0, 0>> |> :binary.copy(8 * 8 * 19 * 4)

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
    headpos = (point.x + point.y * 8 * 19) * 3 * 8
    taillength = ((state.buffer |> :binary.referenced_byte_size()) - (headpos + 3)) * 8

    Logger.warn("point: #{inspect(point)}")
    Logger.warn("color: #{inspect(color)}")
    Logger.warn("headpos: #{headpos}")
    Logger.warn("taillength: #{taillength}")
    Logger.warn("buffersize: #{(state.buffer |> :binary.referenced_byte_size()) * 8}")

    <<head::size(headpos), r, g, b, tail::size(taillength)>> = state.buffer

    {buffer, dirty} =
      case(%Color{r: r, g: g, b: b}) do
        ^color ->
          {state.buffer, state.dirty}

        _different_color ->
          {<<head::size(headpos), color.r, color.g, color.b, tail::size(taillength)>>, true}
      end

    {:reply, nil, %State{buffer: buffer, dirty: dirty}}
  end

  def handle_call(:render, _from, state) do
    GenServer.call(Blinkchain.HAL, {:blit, %Point{x: 0, y: 0}, @width, @height, state.buffer})

    # state =
    #   case state.dirty do
    #     true ->
    #       state.buffer
    #       |> Enum.each(fn {point, color} ->
    #         Blinkchain.set_pixel(point, color)
    #       end)

    #       Blinkchain.render()
    #       %State{buffer: state.buffer, dirty: false}

    #     false ->
    #       state
    #   end

    {:reply, nil, %State{buffer: state.buffer, dirty: false}}
  end

  def handle_call({:fill, color}, _from, _state) do
    buffer = <<color.r, color.g, color.b>> |> :binary.copy(8 * 8 * 19 * 4)

    {:reply, nil, %State{buffer: buffer, dirty: true}}
  end

  def handle_call({:get_pixel, point}, _from, state) do
    pixel = state.buffer |> Map.get(point)
    {:reply, pixel, state}
  end
end
