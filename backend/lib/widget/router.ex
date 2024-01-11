defmodule Router.Index do

  use Widget.Helper.Common
  import League.Api, only: [getInfo: 3]
  import Api.Json, only: [res: 3]

  get "/" do
    region = conn.query_params["region"] || nil
    gameName = conn.query_params["gamename"] || nil
    tagLine = conn.query_params["tagline"] || nil

    unless region || gameName || tagLine do
      res(conn, %{message: "missing.query"}, 400)
    end

    unless checkRegion?(region) do
      res(conn, %{message: "invalid.region"}, 400)
    end

    case getInfo(String.downcase(region), gameName, tagLine) do
      {:ok, data, _} ->
        res(conn, %{data: data}, 200)
      {:error, data} ->
        {code, message} = data
        res(conn, %{error: message}, code)
    end
  end

  match _ do
    res(conn, %{
        code: 404,
        error: true,
        message: "invalid route"
    }, 404)
  end

  def checkRegion?(region) do
    Enum.member?(["br", "kr"], String.downcase(region))
  end

end
