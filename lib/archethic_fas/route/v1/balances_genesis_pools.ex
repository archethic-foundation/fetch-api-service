defmodule ArchethicFAS.Route.V1.BalancesGenesisPools do
  @moduledoc """
  Return the Balances of the 7 genesis pools.
  May return null values if cache is not hydrated (a few seconds after a restart).
  """

  require Logger
  import Plug.Conn

  alias ArchethicFAS.Balances

  def init(opts), do: opts

  def call(conn, _opts) do
    body =
      Balances.get_genesis_pools_balances()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end
end
