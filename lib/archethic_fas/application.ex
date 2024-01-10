defmodule ArchethicFAS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ArchethicFAS.Router, options: [port: 3000]},
      ArchethicFAS.Quotes.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArchethicFAS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end