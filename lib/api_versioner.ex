defmodule ApiVersioner do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(__MODULE__, [], function: :run)
    ]

    Logger.info("Started application")

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def run do
    { :ok, _ } = Plug.Adapters.Cowboy.http ApiVersioner.ByHeader, accepts: Application.get_env(:mime, :types), default: :v1
  end
end