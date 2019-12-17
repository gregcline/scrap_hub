defmodule ScrapHub.Scene.ForecastNow do
  use Scenic.Component
  alias ScrapHub.DarkSky
  alias ScrapHub.Scene.Weather
  alias ScrapHub.WeatherIcons
  alias Scenic.Graph
  alias Scenic.Cache
  import Scenic.Primitives
  import Scenic.Components
  import Logger

  @container_width 180
  @container_height 440

  def init({:ok, weather}, _opts) do
    graph =
      case weather do
        nil ->
          build_no_weather(Graph.build())

        weather ->
          build_graph(Graph.build(), weather["currently"])
      end

    {:ok, graph, push: graph}
  end

  def info(),
    do: """
    This component is intended to display the weather now
    """

  def verify({:ok, weather}) do
    {:ok, weather}
  end

  def verify({:error, reason}) do
    Logger.warn(reason)
    {:ok, nil}
  end

  defp build_no_weather(graph) do
    graph
    |> add_background()
    |> text(
      "Sorry\nAliens stole the\ncurrent weather\nreport.",
      font_size: 26,
      translate: {20, 20}
    )
    |> text(
      WeatherIcons.get_icon("wi_alien"),
      font: WeatherIcons.icon_font(),
      font_size: 40,
      translate: {80, 200}
    )
  end

  defp build_graph(graph, weather) do
    graph
    |> add_background()
    |> add_title(weather)
    |> add_summary(weather)
    |> add_temperature(weather)
    |> add_pressure(weather)
    |> add_dew_point(weather)
    |> add_wind_speed(weather)
    |> add_wind_gust(weather)
    |> add_wind_indicator(weather)
  end

  defp add_background(graph) do
    graph
    |> rounded_rectangle(
      {@container_width, @container_height, 5},
      fill: {0x0B, 0x2F, 0x40},
      stroke: {2, {0x17, 0x5E, 0x80}}
    )
  end

  defp add_title(graph, weather) do
    graph
    |> text("Right Now", font_size: 30, translate: {10, 25}, id: :title)
    |> add_weather_icon(weather)
  end

  defp add_weather_icon(graph, weather) do
    graph
    |> text(
      WeatherIcons.dark_sky_icon(weather["icon"]),
      font: WeatherIcons.icon_font(),
      font_size: 30,
      translate: {130, 25},
      id: :title_icon
    )
  end

  defp add_summary(graph, weather) do
    graph
    |> text(
      weather["summary"],
      font_size: 26,
      translate: {18, 50},
      id: :summary
    )
  end

  defp add_temperature(graph, weather) do
    graph
    |> text(
      "#{weather["temperature"]}°F",
      font_size: 20,
      translate: {18, 75},
      id: :temp
    )
  end

  defp add_dew_point(graph, weather) do
    graph
    |> text(
      "Dew point: #{weather["dewPoint"]}°F",
      font_size: 20,
      translate: {18, 100},
      id: :dew_point
    )
  end

  defp add_pressure(graph, weather) do
    graph
    |> text(
      "Pressure: #{weather["pressure"]} MB",
      font_size: 20,
      translate: {18, 125},
      id: :pressure
    )
  end

  defp add_wind_speed(graph, weather) do
    graph
    |> text(
      "Wind Speed: #{weather["windSpeed"]}\n MPH",
      font_size: 20,
      translate: {18, 150},
      id: :wind_speed
    )
  end

  defp add_wind_gust(graph, weather) do
    graph
    |> text(
      "Wind Gust: #{weather["windGust"]}\n MPH",
      font_size: 20,
      translate: {18, 200},
      id: :wind_gust
    )
  end

  defp add_wind_indicator(graph, weather) do
    # The bearing is where the wind is coming from
    bearing = DarkSky.deg_to_radian(weather["windBearing"])

    graph
    |> text(
      "Wind direction: ",
      font_size: 20,
      translate: {18, 250},
      id: :wind_direction_text
    )
    |> triangle(
      {{5, 0}, {0, 12}, {10, 12}},
      translate: {140, 238},
      rotate: bearing + :math.pi(),
      fill: :white,
      id: :wind_direction_indicator
    )
  end
end
