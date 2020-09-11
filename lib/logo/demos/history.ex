defmodule Logo.Demos.History do
  alias Logo.Demos.History.Png
  alias Logo.Demos.History.Cbp
  alias Logo.Skil

  require Logger

  require IEx

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    timestamps = get_timestamps()
    {:ok, ref} = :timer.send_interval(33, :draw_frame)
    {:ok, %{timestamps: timestamps, timer: ref}}
  end

  def handle_info(:draw_frame, %{timestamps: [], ref: ref}) do
    timestamps = get_timestamps()
    {:ok, %{timestamps: timestamps, ref: ref}}
  end

  def handle_info(:draw_frame, %{timestamps: timestamps, ref: ref}) do
    [timestamp | rest] = timestamps
    timestamp |> get_frame() |> draw_logo()
    {:ok, %{timestamps: rest, ref: ref}}
  end

  def get_timestamps() do
    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.get("https://logo-png.app.iterate.no/api/v1/history/index"),
         {:ok, times} <- Jason.decode(body) do
      times |> Enum.map(&Map.get(&1, "time"))
    end
  end

  def get_frame(timestamp) do
    {:ok, %HTTPoison.Response{body: body}} =
      "https://logo-png.app.iterate.no/api/v1/history/#{timestamp}" |> HTTPoison.get()

    body |> Png.parse_raw_png() |> Png.to_xy() |> get_cbp_from_xy()
  end

  def get_cbp_from_xy(xy) do
    [
      # i
      character(0, 3, xy),
      # t
      character(1, 7, xy),
      # e
      character(2, 7, xy),
      # r
      character(3, 5, xy),
      # a
      character(4, 7, xy),
      # t
      character(5, 7, xy),
      # e
      character(6, 7, xy)
    ]
  end

  defp character(char_number, number_of_blocks, xy) do
    for b <- 0..(number_of_blocks - 1) do
      for p <- 0..63 do
        {x, y} = Cbp.cbp_ref_to_coordinate({char_number, b, p})
        get_rgb(xy, x, y) |> rgb_to_hextring()
      end
    end
  end

  defp get_rgb(xy, x, y) do
    {r, g, b} = xy |> Enum.at(y) |> Enum.at(x)
    {r, g, b}
  end

  defp rgb_to_hextring({r, g, b}) do
    "\##{hex(r)}#{hex(g)}#{hex(b)}"
  end

  defp hex(n) do
    Integer.to_string(n, 16) |> String.pad_leading(2, "0")
  end

  def draw_logo(cbp) do
    Skilt.fill(%Blinkchain.Color{r: 0, g: 0, b: 0})

    [i, t1, e1, r, a, t2, e2] = cbp

    draw_block(i, 0, {0, 0})
    draw_block(i, 1, {0, 2})
    draw_block(i, 2, {0, 3})

    draw_block(t1, 0, {1, 0})
    draw_block(t1, 1, {1, 1})
    draw_block(t1, 2, {2, 1})
    draw_block(t1, 3, {1, 2})
    draw_block(t1, 4, {1, 3})
    draw_block(t1, 5, {2, 3})
    draw_block(t1, 6, {3, 3})

    draw_block(e1, 0, {4, 1})
    draw_block(e1, 1, {5, 1})
    draw_block(e1, 2, {6, 1})
    draw_block(e1, 3, {4, 2})
    draw_block(e1, 4, {6, 2})
    draw_block(e1, 5, {4, 3})
    draw_block(e1, 6, {5, 3})

    draw_block(r, 0, {7, 1})
    draw_block(r, 1, {8, 1})
    draw_block(r, 2, {9, 1})
    draw_block(r, 3, {7, 2})
    draw_block(r, 4, {7, 3})

    draw_block(a, 0, {11, 1})
    draw_block(a, 1, {12, 1})
    draw_block(a, 2, {10, 2})
    draw_block(a, 3, {12, 2})
    draw_block(a, 4, {10, 3})
    draw_block(a, 5, {11, 3})
    draw_block(a, 6, {12, 3})

    draw_block(t2, 0, {13, 0})
    draw_block(t2, 1, {13, 1})
    draw_block(t2, 2, {14, 1})
    draw_block(t2, 3, {13, 2})
    draw_block(t2, 4, {13, 3})
    draw_block(t2, 5, {14, 3})
    draw_block(t2, 6, {15, 3})

    draw_block(e2, 0, {16, 1})
    draw_block(e2, 1, {17, 1})
    draw_block(e2, 2, {18, 1})
    draw_block(e2, 3, {16, 2})
    draw_block(e2, 4, {18, 2})
    draw_block(e2, 5, {16, 3})
    draw_block(e2, 6, {17, 3})

    Skilt.render()
  end

  def draw_block(letter, block, block_position) do
    {block_x, block_y} = block_position

    letter
    |> Enum.at(block)
    |> Enum.chunk_every(8)
    |> Enum.with_index()
    |> Enum.each(fn {row, rowindex} ->
      row
      |> Enum.with_index()
      |> Enum.each(fn {colorstring, columnindex} ->
        Skilt.set_pixel(
          %Blinkchain.Point{x: columnindex + block_x * 8, y: rowindex + block_y * 8},
          Blinkchain.Color.parse(colorstring)
        )
      end)
    end)
  end
end
