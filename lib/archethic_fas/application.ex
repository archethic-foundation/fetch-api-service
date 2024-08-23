defmodule ArchethicFAS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    port = Application.fetch_env!(:archethic_fas, :api_port)

    Logger.info("Server HTTP bound to port: #{port}")

    children = [
      {Plug.Cowboy, scheme: :http, plug: ArchethicFAS.Router, options: [port: port]},
      ArchethicFAS.Quotes.Supervisor,
      ArchethicFAS.AESwap.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArchethicFAS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
