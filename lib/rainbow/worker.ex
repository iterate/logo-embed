defmodule Rainbow.Worker do
  use GenServer

  alias Blinkchain.Point

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, nil}
  end

  def handle_cast({:bench, _intensity, color}, _state) do
    Blinkchain.fill(%Point{x: 0, y: 0}, 8, 8, color)
    Blinkchain.render()
    {:noreply, nil}
  end
end
