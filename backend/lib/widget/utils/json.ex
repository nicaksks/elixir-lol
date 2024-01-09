defmodule Api.Json do

  import Plug.Conn

  def send(conn, data \\ %{}, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
