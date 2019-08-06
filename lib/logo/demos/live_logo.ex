defmodule Logo.Demos.LiveLogo do
  require Logger

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    # Send ourselves a message to draw each frame every 33 ms,
    # which will end up being approximately 15 fps.
    {:ok, ref} = :timer.send_interval(1000, :draw_frame)

    {:ok, ref}
  end

  def handle_info(:draw_frame, state) do
    case Logo.Api.get_mode() do
      {:ok, "\"logo\""} -> Logo.Api.draw_logo(false)
      {:ok, "\"iteralogo\""} -> Logo.Api.draw_logo(true)
      {:error, _error} -> Logger.warn("Could not get mode!")
    end

    {:noreply, state}
  end
end
