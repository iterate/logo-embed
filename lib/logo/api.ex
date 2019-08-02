defmodule Logo.Api do
  def get_latest() do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get("https://logo.app.iterate.no/logo")
    body |> Jason.decode!() |> Map.get("logo")
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

  def draw_logo do
    [i, t1, _e, _r, _a, _t2, e2] = get_latest()

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

    draw_block(e2, 0, {16, 1})
    draw_block(e2, 1, {17, 1})
    draw_block(e2, 2, {18, 1})
    draw_block(e2, 3, {16, 2})
    draw_block(e2, 4, {18, 2})
    draw_block(e2, 5, {16, 3})
    draw_block(e2, 6, {17, 3})

    Blinkchain.render()
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
        Blinkchain.set_pixel(
          %Blinkchain.Point{x: columnindex + block_x * 8, y: rowindex + block_y * 8},
          Blinkchain.Color.parse(colorstring)
        )
      end)
    end)
  end
end
