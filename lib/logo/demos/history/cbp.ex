defmodule Logo.Demos.History.Cbp do
  def cbp_ref_to_coordinate({character, block, pixel}) do
    {0, 0}
    |> apply_character_offset(character)
    |> apply_block_offset(character, block)
    |> apply_pixel_offset(pixel)
  end

  defp apply_character_offset({x, y}, character) do
    block_width = 8
    character_width = 3 * block_width

    offset =
      case character do
        0 ->
          0

        _ ->
          # all characters except the first are three blocks wide
          (character - 1) * character_width + block_width
      end

    {x + offset, y}
  end

  defp apply_block_offset({x, y}, character, block) do
    {offset_x, offset_y} =
      case character do
        # i
        0 ->
          case block do
            0 -> {0, 0}
            1 -> {0, 2}
            2 -> {0, 3}
          end

        # t
        1 ->
          case block do
            0 -> {0, 0}
            1 -> {0, 1}
            2 -> {1, 1}
            3 -> {0, 2}
            4 -> {0, 3}
            5 -> {1, 3}
            6 -> {2, 3}
          end

        # e
        2 ->
          case block do
            0 -> {0, 1}
            1 -> {1, 1}
            2 -> {2, 1}
            3 -> {0, 2}
            4 -> {2, 2}
            5 -> {0, 3}
            6 -> {1, 3}
          end

        # r
        3 ->
          case block do
            0 -> {0, 1}
            1 -> {1, 1}
            2 -> {2, 1}
            3 -> {0, 2}
            4 -> {0, 3}
          end

        # a
        4 ->
          case block do
            0 -> {1, 1}
            1 -> {2, 1}
            2 -> {0, 2}
            3 -> {2, 2}
            4 -> {0, 3}
            5 -> {1, 3}
            6 -> {2, 3}
          end

        # t
        5 ->
          case block do
            0 -> {0, 0}
            1 -> {0, 1}
            2 -> {1, 1}
            3 -> {0, 2}
            4 -> {0, 3}
            5 -> {1, 3}
            6 -> {2, 3}
          end

        # e
        6 ->
          case block do
            0 -> {0, 1}
            1 -> {1, 1}
            2 -> {2, 1}
            3 -> {0, 2}
            4 -> {2, 2}
            5 -> {0, 3}
            6 -> {1, 3}
          end

        _ ->
          {0, 0}
      end

    {x + offset_x * 8, y + offset_y * 8}
  end

  defp apply_pixel_offset({x, y}, pixel) do
    offset_x = rem(pixel, 8)
    offset_y = div8(pixel)
    {x + offset_x, y + offset_y}
  end

  def coordinate_to_cbpRef(coord) do
    {cbp, {0, 0}} =
      {{0, 0, 0}, coord}
      |> extract_character()
      |> extract_block()
      |> extract_pixel()

    cbp
  end

  defp extract_character({{_c, b, p}, {x, y}}) do
    c =
      case x < 8 do
        true -> 0
        false -> ((x - 1) |> div(8) |> div(3)) + 1
      end

    x_offset =
      cond do
        c == 0 -> 0
        c == 1 -> 8
        true -> (c - 1) * 8 * 3 + 8
      end

    {{c, b, p}, {x - x_offset, y}}
  end

  defp extract_block({{c, _b, p}, {x, y}}) do
    b =
      case c do
        0 ->
          case div8(y) do
            0 -> 0
            1 -> :illegal_coordinate
            2 -> 1
            3 -> 2
          end

        1 ->
          case div8({x, y}) do
            {0, 0} -> 0
            {0, 1} -> 1
            {1, 1} -> 2
            {0, 2} -> 3
            {0, 3} -> 4
            {1, 3} -> 5
            {2, 3} -> 6
          end

        2 ->
          case div8({x, y}) do
            {0, 1} -> 0
            {1, 1} -> 1
            {2, 1} -> 2
            {0, 2} -> 3
            {2, 2} -> 4
            {0, 3} -> 5
            {1, 3} -> 6
          end

        3 ->
          case div8({x, y}) do
            {0, 1} -> 0
            {1, 1} -> 1
            {2, 1} -> 2
            {0, 2} -> 3
            {0, 3} -> 4
          end

        4 ->
          case div8({x, y}) do
            {1, 1} -> 0
            {2, 1} -> 1
            {0, 2} -> 2
            {2, 2} -> 3
            {0, 3} -> 4
            {1, 3} -> 5
            {2, 3} -> 6
          end

        5 ->
          case div8({x, y}) do
            {0, 0} -> 0
            {0, 1} -> 1
            {1, 1} -> 2
            {0, 2} -> 3
            {0, 3} -> 4
            {1, 3} -> 5
            {2, 3} -> 6
          end

        6 ->
          case div8({x, y}) do
            {0, 1} -> 0
            {1, 1} -> 1
            {2, 1} -> 2
            {0, 2} -> 3
            {2, 2} -> 4
            {0, 3} -> 5
            {1, 3} -> 6
          end
      end

    {{c, b, p}, {rem(x, 8), rem(y, 8)}}
  end

  defp extract_pixel({{c, b, _p}, {x, y}}) do
    {{c, b, x + y * 8}, {0, 0}}
  end

  defp div8({x, y}) do
    {div8(x), div8(y)}
  end

  defp div8(x) do
    div(x, 8)
  end
end
