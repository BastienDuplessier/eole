defmodule Eole.Supervisor do
  use Supervisor
  @registry :eole_registry

  def init(_) do
    children = [
      supervisor(Registry, [[keys: :unique, name: @registry]]),
      worker(Eole.Server, [], id: :server)
    ]

    supervise(children, strategy: :one_for_all)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

end
