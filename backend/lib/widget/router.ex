defmodule Router.Index do

  use Widget.Helper.Common

  get "/" do
    region = conn.query_params["region"] || nil
    gameName = conn.query_params["gamename"] || nil
    tagLine = conn.query_params["tagline"] || nil

    unless region || gameName || tagLine do
      Api.Json.send(conn, %{message: "missing.query"}, 400)
    end

    unless checkRegion?(region) do
      Api.Json.send(conn, %{message: "invalid.region"}, 400)
    end

    case League.Api.getInfo(String.downcase(region), gameName, tagLine) do
      {:ok, data, _} ->
        Api.Json.send(conn, %{data: data}, 200)
      {:error, data} ->
        {code, message} = data
        Api.Json.send(conn, %{error: message}, code)
    end
  end

  match _ do
    Api.Json.send(conn, %{
      error: %{
        code: 404,
        error: true,
        message: "route invalid"
      },
      type: "query",
      message: "Use: ?region={ asia | americas | europe }&gamename=annie&tagline=annie"
    }, 200)
  end

  def checkRegion?(region) do
    Enum.member?(["br", "kr"], String.downcase(region))
  end

end
