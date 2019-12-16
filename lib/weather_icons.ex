defmodule ScrapHub.WeatherIcons do
  alias Scenic.Cache

  @icon_map :code.priv_dir(:scrap_hub)
            |> Path.join("/static/weather_icons/weathericons_names.xml")
            |> File.read!()
            |> String.split("\n")
            |> Stream.map(
              &Regex.named_captures(~r/<string name="(?<name>.+)">&#x(?<code>.+);<\/string>/, &1)
            )
            |> Stream.filter(fn x -> !is_nil(x) end)
            |> Enum.reduce(%{}, fn %{"name" => name, "code" => code}, acc ->
              Map.put(acc, name, code)
            end)

  @custom_font_folder :code.priv_dir(:scrap_hub) |> Path.join("/static/weather_icons")
  @custom_font_hash "F2vaZmHyE93kfCEU125HbsjKmq4H3VT5VQ0tKP4CtP0"
  @custom_metrics_path :code.priv_dir(:scrap_hub)
                       |> Path.join(
                         "/static/weather_icons/weathericons-regular-webfont.ttf.metrics"
                       )
  @custom_metrics_hash Cache.Support.Hash.file!(@custom_metrics_path, :sha)

  def custom_font_folder(), do: @custom_font_folder
  def custom_font_hash(), do: @custom_font_hash
  def custom_metrics_path(), do: @custom_metrics_path
  def custom_metrics_hash(), do: @custom_metrics_hash

  def icon_font(), do: @custom_metrics_hash

  def get_icon(name) do
    icon =
      @icon_map
      |> Map.get(name)
      |> String.to_integer(16)

    <<icon::utf8>>
  end

  def all_icons(), do: @icon_map

  @dark_sky_mapping [
    {"clear-day", "wi_day_sunny"},
    {"clear-night", "wi_night_clear"},
    {"rain", "wi_day_rain"},
    {"snow", "wi_day_snow"},
    {"sleet", "wi_day_sleet"},
    {"wind", "wi_day_windy"},
    {"fog", "wi_day_fog"},
    {"cloudy", "wi_day_cloudy"},
    {"partly-cloudy-day", "wi_day_cloudy"},
    {"partly-cloudy-night", "wi_night_cloudy"}
  ]

  for {ds_name, wi_name} <- @dark_sky_mapping do
    def dark_sky_icon(unquote(ds_name)), do: get_icon(unquote(wi_name))
  end

  def dark_sky_icon(_), do: get_icon("wi-na")
end
