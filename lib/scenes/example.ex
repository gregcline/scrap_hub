defmodule ScrapHub.Scene.Weather do
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.Cache
  alias ScrapHub.WeatherIcons
  import Scenic.Primitives
  import Scenic.Components

  @custom_font_folder :code.priv_dir(:scrap_hub) |> Path.join("/static/weather_icons")
  @custom_font_hash "F2vaZmHyE93kfCEU125HbsjKmq4H3VT5VQ0tKP4CtP0"
  @custom_metrics_path :code.priv_dir(:scrap_hub) |> Path.join("/static/weather_icons/weathericons-regular-webfont.ttf.metrics")
  @custom_metrics_hash Cache.Support.Hash.file!(@custom_metrics_path, :sha)

  @graph Graph.build()
    |> text("Hello world", font_size: 22, translate: {20, 80})
    |> button("Do something", id: :btn_something, translate: {20, 180})
    |> text("", font: @custom_metrics_hash, font_size: 22, translate: {20, 20})
    |> text(WeatherIcons.get_icon("wi_day_sunny"), font: @custom_metrics_hash, font_size: 22, translate: {20, 40})


  def init(_scene_args, _options) do
    Cache.Static.Font.load(@custom_font_folder, @custom_font_hash)
    Cache.Static.FontMetrics.load(@custom_metrics_path, @custom_metrics_hash)

    {:ok, @graph, push: @graph}
  end
end
