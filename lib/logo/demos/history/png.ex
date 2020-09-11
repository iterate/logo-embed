defmodule Logo.Demos.History.Png do
  alias Logo.Demos.History.Png

  defstruct width: nil,
            height: nil,
            bit_depth: nil,
            color_type: nil,
            compression_method: nil,
            filter_method: nil,
            interlace_method: nil,
            data: <<>>

  defmodule Chunk do
    defstruct [:length, :type, :data, :crc]

    def split_into_chunks(
          <<chunk_length::size(32), chunk_type::binary-size(4), data::binary-size(chunk_length),
            crc::size(32), rest::binary>>
        ) do
      [%Chunk{length: chunk_length, type: chunk_type, data: data, crc: crc}] ++
        split_into_chunks(rest)
    end

    def split_into_chunks(<<>>) do
      []
    end
  end

  def parse_raw_png(raw) do
    <<137, 80, 78, 71, 13, 10, 26, 10>> <> <<data::binary>> = raw

    data |> Chunk.split_into_chunks() |> Enum.reduce(%Png{}, &apply_chunk/2)
  end

  defp apply_chunk(%Chunk{type: "IHDR"} = chunk, png) do
    <<width::size(32), height::size(32), bit_depth, color_type, compression_method, filter_method,
      interlace_method>> = chunk.data

    %Png{
      png
      | width: width,
        height: height,
        bit_depth: bit_depth,
        color_type: color_type,
        compression_method: compression_method,
        filter_method: filter_method,
        interlace_method: interlace_method
    }
  end

  defp apply_chunk(%Chunk{type: "IDAT"} = chunk, png) do
    %Png{png | data: chunk.data}
  end

  defp apply_chunk(%Chunk{type: "IEND"}, png) do
    png
  end

  def to_xy(%Png{width: width, data: data}) do
    uncompressed = data |> :zlib.uncompress()
    extract_scanlines(uncompressed, width)
  end

  defp extract_scanlines(<<1>> <> <<data::binary>>, width)
       when byte_size(data) >= width * 4 do
    byte_width = width * 4
    <<scanline::binary-size(byte_width), rest::binary>> = data
    [defilter(scanline) |> rgbasize()] ++ extract_scanlines(rest, width)
  end

  defp extract_scanlines(<<>>, _width) do
    []
  end

  defp rgbasize([r, g, b, _a | rest]) do
    [{r, g, b}] ++ rgbasize(rest)
  end

  defp rgbasize([]) do
    []
  end

  defp defilter(scanline) do
    defilter(scanline, <<0, 0, 0, 0>>)
  end

  defp defilter(<<r, g, b, a, rest::binary>>, <<prev_r, prev_g, prev_b, prev_a>>) do
    this_r = (r + prev_r) |> rem(256)
    this_g = (g + prev_g) |> rem(256)
    this_b = (b + prev_b) |> rem(256)
    this_a = (a + prev_a) |> rem(256)

    [this_r, this_g, this_b, this_a] ++ defilter(rest, <<this_r, this_g, this_b, this_a>>)
  end

  defp defilter(<<>>, _) do
    []
  end
end
