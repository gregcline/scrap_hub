defmodule ScrapHub.DarkSky do
  @url "https://api.darksky.net/forecast"
  @key Application.fetch_env!(:scrap_hub, :dark_sky_key)

  @spec deg_to_radian(Integer.t()) :: Float.t()
  def deg_to_radian(degrees) do
    degrees * :math.pi() / 180
  end

  @spec forecast(String.t(), String.t()) :: {:ok, %{}} | {:error, String.t()}
  def forecast(lat, lng) do
    Mojito.get("#{@url}/#{@key}/#{lat},#{lng}")
    |> rate_limit?()
    |> decode_body()
  end

  defp rate_limit?(response = {:ok, %{headers: headers}}) do
    case Mojito.Headers.get(headers, "x-forecast-api-calls") do
      nil ->
        {:error, "No API calls header"}

      "1000" ->
        {:error, "Rate limit exceeded"}

      _ ->
        response
    end
  end

  defp decode_body(response = {:error, _}), do: response

  defp decode_body({:ok, %{body: body}}) do
    case Jason.decode(body) do
      {:error, _} = err ->
        err

      body ->
        body
    end
  end
end
