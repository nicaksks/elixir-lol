defmodule League.Api do

  @token Application.compile_env(:widget, :token)

  @headers [
    {"content-type", "application/json"},
    {"X-Riot-Token", @token}
  ]

  @select %{
    "br" => %{
      "plataform" => "br1",
      "region" => "americas",
    },
    "kr" =>	%{
      "plataform" => "kr",
      "region" => "asia"
    }
  }

  defp instance(sub, endpoint, region \\ nil) do
    case HTTPoison.get("https://#{sub}.api.riotgames.com/#{endpoint}", @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, Jason.decode!(body), region}
      {:ok, %HTTPoison.Response{status_code: 401}} -> {:error, {401, "unauthorized"}}
      {:ok, %HTTPoison.Response{status_code: 403}} -> {:error, {403, "forbidden"}}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, {404, "player.not.found"}}
      {:ok, %HTTPoison.Response{status_code: 429}} -> {:error, {429, "rate.limit"}}
      _-> {:error, "internal error"}
    end
  end

  defp puuid(region, gameName, tagLine), do: instance(@select[region]["region"], "riot/account/v1/accounts/by-riot-id/#{gameName}/#{tagLine}", region)

  defp id({:ok, data, region}), do: instance(@select[region]["plataform"], "lol/summoner/v4/summoners/by-puuid/#{data["puuid"]}", region)
  defp id({:error, message}), do: {:error, message}

  defp ranked({:ok, data, region}), do: instance(@select[region]["plataform"], "lol/league/v4/entries/by-summoner/#{data["id"]}")
  defp ranked({:error, message}), do: {:error, message}

  def getInfo(region, gameName, tagLine) do
    region
    |> puuid(gameName, tagLine)
    |> id()
    |> ranked()
  end

end
