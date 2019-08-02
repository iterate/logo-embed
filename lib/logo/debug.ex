defmodule Logo.Debug do
  def configure_full_sign do
    Application.put_env(:blinkchain, :canvas, {8, 8 * 43})

    channel0_arrangement =
      for n <- 1..22,
          do: %{
            type: :matrix,
            origin: {0, (n - 1) * 8},
            count: {8, 8},
            direction: {:right, :down},
            progressive: true
          }

    channel1_arrangement =
      for n <- 23..43,
          do: %{
            type: :matrix,
            origin: {0, (n - 1) * 8},
            count: {8, 8},
            direction: {:right, :down},
            progressive: true
          }

    Application.put_env(:blinkchain, :channel0,
      pin: 18,
      type: :grb,
      brightness: 32,
      gamma: Logo.Debug.Gamma.gamma(),
      arrangement: channel0_arrangement
    )

    Application.put_env(:blinkchain, :channel1,
      pin: 13,
      type: :grb,
      brightness: 32,
      gamma: Logo.Debug.Gamma.gamma(),
      arrangement: channel1_arrangement
    )

    reload()
  end

  def arrrrangement do
    channel0 = [
      # 0
      {0, 0},
      {1, 0},
      {1, 1},
      {2, 1},
      {1, 2},
      {0, 2},
      {0, 3},
      {1, 3},
      {2, 3},
      {3, 3},
      # 10
      {4, 3},
      {5, 3},
      {4, 2},
      {4, 1},
      {5, 1},
      {6, 1},
      {6, 2},
      {7, 3},
      {7, 2},
      {7, 1},
      # 20
      {8, 1},
      {9, 1}
    ]

    channel1 = [
      # 22
      {10, 2},
      {10, 3},
      {11, 3},
      {12, 3},
      {12, 2},
      {12, 1},
      {11, 1},
      {13, 1},
      # 30
      {13, 0},
      {13, 2},
      {13, 3},
      {14, 1},
      {14, 3},
      {15, 3},
      {16, 3},
      {17, 3},
      {16, 2},
      {16, 1},
      {17, 1},
      {18, 1},
      {18, 2}
    ]

    Application.put_env(:blinkchain, :canvas, {8 * 19, 8 * 4})

    channel0_arrangement =
      for {x, y} <- channel0,
          do: %{
            type: :matrix,
            origin: {x * 8, y * 8},
            count: {8, 8},
            direction: {:right, :down},
            progressive: true
          }

    channel1_arrangement =
      for {x, y} <- channel1,
          do: %{
            type: :matrix,
            origin: {x * 8, y * 8},
            count: {8, 8},
            direction: {:right, :down},
            progressive: true
          }

    Application.put_env(:blinkchain, :channel0,
      pin: 18,
      type: :grb,
      brightness: 32,
      gamma: Logo.Debug.Gamma.gamma(),
      arrangement: channel0_arrangement
    )

    Application.put_env(:blinkchain, :channel1,
      pin: 13,
      type: :grb,
      brightness: 32,
      gamma: Logo.Debug.Gamma.gamma(),
      arrangement: channel1_arrangement
    )

    reload()
  end

  def drawblock(n) do
    {:ok, {width, height}} = Application.fetch_env(:blinkchain, :canvas)
    Blinkchain.fill(%Blinkchain.Point{x: 0, y: 0}, width, height, black())

    Blinkchain.fill(point(0, 8 * n), 8, 8, blue())
    Blinkchain.render()
  end

  def reload do
    Blinkchain.HAL |> Process.whereis() |> Process.exit(:kill)
  end

  def red, do: Blinkchain.Color.parse("#ff0000")
  def blue, do: Blinkchain.Color.parse("#0000ff")
  def green, do: Blinkchain.Color.parse("#00ff00")
  def black, do: Blinkchain.Color.parse("#000000")

  def all_red do
    {:ok, {width, height}} = Application.fetch_env(:blinkchain, :canvas)
    Blinkchain.fill(%Blinkchain.Point{x: 0, y: 0}, width, height, red())
    Blinkchain.render()
  end

  def all_blue do
    {:ok, {width, height}} = Application.fetch_env(:blinkchain, :canvas)
    Blinkchain.fill(%Blinkchain.Point{x: 0, y: 0}, width, height, blue())
    Blinkchain.render()
  end

  def all_black do
    {:ok, {width, height}} = Application.fetch_env(:blinkchain, :canvas)
    Blinkchain.fill(%Blinkchain.Point{x: 0, y: 0}, width, height, black())
    Blinkchain.render()
  end

  def test_pattern do
    Blinkchain.set_pixel(%Blinkchain.Point{x: 0, y: 0}, red())
    Blinkchain.set_pixel(%Blinkchain.Point{x: 3, y: 11}, green())
    Blinkchain.set_pixel(%Blinkchain.Point{x: 4, y: 12}, green())
    Blinkchain.set_pixel(%Blinkchain.Point{x: 15, y: 15}, blue())
    Blinkchain.render()
  end

  def test_pattern_inner_square do
    {:ok, {width, height}} = Application.fetch_env(:blinkchain, :canvas)
    Blinkchain.fill(point(0, 0), width, height, blue())
    Blinkchain.fill(point(div(width, 4), div(height, 4)), div(width, 2), div(height, 2), red())
    Blinkchain.render()
  end

  def point(x, y) do
    %Blinkchain.Point{x: x, y: y}
  end

  def line(p1, p2, color) do
    dx = p2.x - p1.x
    dy = p2.y - p1.y

    for x <- p1.x..p2.x do
      y = (p1.y + dy * (x - p1.x) / dx) |> trunc()
      %Blinkchain.Point{x: x, y: y}
    end
    |> Enum.map(fn point ->
      Blinkchain.set_pixel(point, color)
    end)

    Blinkchain.render()
  end
end
