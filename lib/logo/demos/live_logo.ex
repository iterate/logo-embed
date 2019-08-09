defmodule Logo.Demos.LiveLogo do
  require Logger

  use GenServer

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
    case Logo.Api.get_mode() do
      {:ok, "\"logo\""} -> Logo.Api.draw_logo_blinkchain(false)
      {:ok, "\"iteralogo\""} -> Logo.Api.draw_logo_blinkchain(true)
      {:ok, "\"off\""} -> Logo.Debug.all_black()
      {:ok, "\"rainbow\""} -> send(Rainbow.Worker, :draw_frame)
      {:error, _error} -> Logger.warn("Could not get mode!")
    end

    {:noreply, state}
  end
end
