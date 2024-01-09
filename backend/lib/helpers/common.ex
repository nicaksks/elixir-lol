defmodule Widget.Helper.Common do
  defmacro __using__(_) do
    quote do

      use Plug.Router

      plug :match

      plug CORSPlug,
      origin: ["http://localhost:5500"],
      method: ["GET"],
      accepts: ["json"]

      plug Plug.Parsers,
           parsers: [:urlencoded, :json],
           pass:  ["application/json"],
           json_decoder: Jason

      plug :dispatch
    end
  end
end
