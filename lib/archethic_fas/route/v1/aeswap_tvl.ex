defmodule ArchethicFAS.Route.V1.AESwapTVL do
  @moduledoc """
  Return the TVL of AESwap
  """

  require Logger
  import Plug.Conn

  alias ArchethicFAS.AESwap

  def init(opts), do: opts

  def call(conn, _opts) do
    case AESwap.get_tvl() do
      {:ok, tvl} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{tvl: tvl}))

      :error ->
        conn
        |> send_resp(500, "Internal Error")
    end
  end
end
