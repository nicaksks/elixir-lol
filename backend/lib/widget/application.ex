defmodule Widget.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [{Plug.Cowboy, scheme: :http, plug: Router.Index, options: [port: 3001]}]

    opts = [strategy: :one_for_one, name: Widget.Supervisor]
    IO.puts("Api Online.")
    Supervisor.start_link(children, opts)
  end
end
