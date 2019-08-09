defmodule Logo.Debug.Benchmark do
  def benchmark!() do
    Benchee.run(
      %{
        "skilt" => fn ->
          Logo.Api.draw_logo(false)
        end,
        "blink" => fn ->
          Logo.Api.draw_logo_blinkchain(false)
        end,
        "binary" => fn ->
          Logo.Api.draw_logo_bin(false)
        end
      },
      formatters: [Benchee.Formatters.Console]
    )
  end
end
