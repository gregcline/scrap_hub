defmodule ScrapHub.Scene.Weather do
  use Scenic.Scene
  alias Scenic.Cache
  alias Scenic.Graph
  alias ScrapHub.DarkSky
  alias ScrapHub.WeatherIcons
  alias ScrapHub.Scene.ForecastNow
  import Scenic.Primitives
  import Scenic.Components

  @lat Application.fetch_env!(:scrap_hub, :lat)
  @lng Application.fetch_env!(:scrap_hub, :lng)

  @graph Graph.build()
         |> text("ScrapHub", font_size: 30, translate: {20, 20})

  def init(_scene_args, _options) do
    Cache.Static.Font.load(WeatherIcons.custom_font_folder(), WeatherIcons.custom_font_hash(),
      scope: :global
    )

    Cache.Static.FontMetrics.load(
      WeatherIcons.custom_metrics_path(),
      WeatherIcons.custom_metrics_hash(),
      scope: :global
    )

    graph =
      @graph
      |> ForecastNow.add_to_graph(DarkSky.forecast(@lat, @lng),
        translate: {10, 30},
        font: WeatherIcons.icon_font()
      )

    {:ok, graph, push: graph}
  end
end
