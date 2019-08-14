defmodule Logo.Api do
  require Logger

  alias Logo.Skilt
  alias Logo.Binskilt

  @logoapi "https://logo-api.g2.iterate.no"

  def get_latest() do
    case HTTPoison.get("#{@logoapi}/logo") do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok, body |> Jason.decode!() |> Map.get("logo")}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_mode() do
    case HTTPoison.get("#{@logoapi}/mode") do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, body}
      {:error, error} -> {:error, error}
    end
  end

  def get_blocks(blocks) do
    # logo = get_latest()

    for {x, _y} <- blocks do
      case x do
        0 -> :i
        x when x in 1..3 -> :t
        x when x in 4..6 -> :e
        x when x in 7..9 -> :r
        x when x in 10..12 -> :a
        x when x in 13..15 -> :t
        x when x in 16..18 -> :e
      end
    end
  end

  def draw_logo(itera) do
    Skilt.fill(%Blinkchain.Color{r: 0, g: 0, b: 0})

    case get_latest() do
      {:error, error} ->
        Logger.warn(inspect(error))

      {:ok, [i, t1, e1, r, a, t2, e2]} ->
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

        if(!itera) do
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
        end

        Skilt.render()
    end
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

  def draw_logo_blinkchain(itera) do
    Blinkchain.fill(%Blinkchain.Point{x: 0, y: 0}, 8 * 19, 8 * 4, %Blinkchain.Color{
      r: 0,
      g: 0,
      b: 0
    })

    case get_latest() do
      {:error, error} ->
        Logger.warn(inspect(error))

      {:ok, [i, t1, e1, r, a, t2, e2]} ->
        draw_block_blinkchain(i, 0, {0, 0})
        draw_block_blinkchain(i, 1, {0, 2})
        draw_block_blinkchain(i, 2, {0, 3})

        draw_block_blinkchain(t1, 0, {1, 0})
        draw_block_blinkchain(t1, 1, {1, 1})
        draw_block_blinkchain(t1, 2, {2, 1})
        draw_block_blinkchain(t1, 3, {1, 2})
        draw_block_blinkchain(t1, 4, {1, 3})
        draw_block_blinkchain(t1, 5, {2, 3})
        draw_block_blinkchain(t1, 6, {3, 3})

        draw_block_blinkchain(e1, 0, {4, 1})
        draw_block_blinkchain(e1, 1, {5, 1})
        draw_block_blinkchain(e1, 2, {6, 1})
        draw_block_blinkchain(e1, 3, {4, 2})
        draw_block_blinkchain(e1, 4, {6, 2})
        draw_block_blinkchain(e1, 5, {4, 3})
        draw_block_blinkchain(e1, 6, {5, 3})

        draw_block_blinkchain(r, 0, {7, 1})
        draw_block_blinkchain(r, 1, {8, 1})
        draw_block_blinkchain(r, 2, {9, 1})
        draw_block_blinkchain(r, 3, {7, 2})
        draw_block_blinkchain(r, 4, {7, 3})

        draw_block_blinkchain(a, 0, {11, 1})
        draw_block_blinkchain(a, 1, {12, 1})
        draw_block_blinkchain(a, 2, {10, 2})
        draw_block_blinkchain(a, 3, {12, 2})
        draw_block_blinkchain(a, 4, {10, 3})
        draw_block_blinkchain(a, 5, {11, 3})
        draw_block_blinkchain(a, 6, {12, 3})

        if(!itera) do
          draw_block_blinkchain(t2, 0, {13, 0})
          draw_block_blinkchain(t2, 1, {13, 1})
          draw_block_blinkchain(t2, 2, {14, 1})
          draw_block_blinkchain(t2, 3, {13, 2})
          draw_block_blinkchain(t2, 4, {13, 3})
          draw_block_blinkchain(t2, 5, {14, 3})
          draw_block_blinkchain(t2, 6, {15, 3})

          draw_block_blinkchain(e2, 0, {16, 1})
          draw_block_blinkchain(e2, 1, {17, 1})
          draw_block_blinkchain(e2, 2, {18, 1})
          draw_block_blinkchain(e2, 3, {16, 2})
          draw_block_blinkchain(e2, 4, {18, 2})
          draw_block_blinkchain(e2, 5, {16, 3})
          draw_block_blinkchain(e2, 6, {17, 3})
        end

        Blinkchain.render()
    end
  end

  def draw_block_blinkchain(letter, block, block_position) do
    {block_x, block_y} = block_position

    letter
    |> Enum.at(block)
    |> Enum.chunk_every(8)
    |> Enum.with_index()
    |> Enum.each(fn {row, rowindex} ->
      row
      |> Enum.with_index()
      |> Enum.each(fn {colorstring, columnindex} ->
        Blinkchain.set_pixel(
          %Blinkchain.Point{x: columnindex + block_x * 8, y: rowindex + block_y * 8},
          Blinkchain.Color.parse(colorstring)
        )
      end)
    end)
  end

  def draw_logo_bin(itera) do
    Binskilt.fill(%Blinkchain.Color{r: 0, g: 0, b: 0})

    case get_latest() do
      {:error, error} ->
        Logger.warn(inspect(error))

      {:ok, [i, t1, e1, r, a, t2, e2]} ->
        draw_block_bin(i, 0, {0, 0})
        draw_block_bin(i, 1, {0, 2})
        draw_block_bin(i, 2, {0, 3})

        draw_block_bin(t1, 0, {1, 0})
        draw_block_bin(t1, 1, {1, 1})
        draw_block_bin(t1, 2, {2, 1})
        draw_block_bin(t1, 3, {1, 2})
        draw_block_bin(t1, 4, {1, 3})
        draw_block_bin(t1, 5, {2, 3})
        draw_block_bin(t1, 6, {3, 3})

        draw_block_bin(e1, 0, {4, 1})
        draw_block_bin(e1, 1, {5, 1})
        draw_block_bin(e1, 2, {6, 1})
        draw_block_bin(e1, 3, {4, 2})
        draw_block_bin(e1, 4, {6, 2})
        draw_block_bin(e1, 5, {4, 3})
        draw_block_bin(e1, 6, {5, 3})

        draw_block_bin(r, 0, {7, 1})
        draw_block_bin(r, 1, {8, 1})
        draw_block_bin(r, 2, {9, 1})
        draw_block_bin(r, 3, {7, 2})
        draw_block_bin(r, 4, {7, 3})

        draw_block_bin(a, 0, {11, 1})
        draw_block_bin(a, 1, {12, 1})
        draw_block_bin(a, 2, {10, 2})
        draw_block_bin(a, 3, {12, 2})
        draw_block_bin(a, 4, {10, 3})
        draw_block_bin(a, 5, {11, 3})
        draw_block_bin(a, 6, {12, 3})

        if(!itera) do
          draw_block_bin(t2, 0, {13, 0})
          draw_block_bin(t2, 1, {13, 1})
          draw_block_bin(t2, 2, {14, 1})
          draw_block_bin(t2, 3, {13, 2})
          draw_block_bin(t2, 4, {13, 3})
          draw_block_bin(t2, 5, {14, 3})
          draw_block_bin(t2, 6, {15, 3})

          draw_block_bin(e2, 0, {16, 1})
          draw_block_bin(e2, 1, {17, 1})
          draw_block_bin(e2, 2, {18, 1})
          draw_block_bin(e2, 3, {16, 2})
          draw_block_bin(e2, 4, {18, 2})
          draw_block_bin(e2, 5, {16, 3})
          draw_block_bin(e2, 6, {17, 3})
        end

        Binskilt.render()
    end
  end

  def draw_block_bin(letter, block, block_position) do
    {block_x, block_y} = block_position

    letter
    |> Enum.at(block)
    |> Enum.chunk_every(8)
    |> Enum.with_index()
    |> Enum.each(fn {row, rowindex} ->
      row
      |> Enum.with_index()
      |> Enum.each(fn {colorstring, columnindex} ->
        Binskilt.set_pixel(
          %Blinkchain.Point{x: columnindex + block_x * 8, y: rowindex + block_y * 8},
          Blinkchain.Color.parse(colorstring)
        )
      end)
    end)
  end
end
