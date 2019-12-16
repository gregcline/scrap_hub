defmodule ScrapHub.WeatherIcons do
  @icon_map :code.priv_dir(:scrap_hub)
    |> Path.join("/static/weather_icons/weathericons_names.xml")
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&Regex.named_captures(~r/<string name="(?<name>.+)">&#x(?<code>.+);<\/string>/, &1))
    |> Stream.filter(fn x -> !is_nil(x) end)
    |> Enum.reduce(%{}, fn %{"name" => name, "code" => code}, acc -> Map.put(acc, name, code) end)

  def get_icon(name) do
    icon = @icon_map
      |> Map.get(name)
      |> String.to_integer(16)

    <<icon::utf8>>
  end

  def all_icons(), do: @icon_map
end
