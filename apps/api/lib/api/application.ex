defmodule API.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, API.Router, [], [port: 5000])
    ]

    opts = [strategy: :one_for_one, name: API.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
