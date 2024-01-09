defmodule ArchethicFAS.Route.V1.QuotesLatest do
  @moduledoc """
  Return the latest quotes for given currencies
  """
  alias ArchethicFAS.Currency

  require Logger
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    currencies_str =
      conn.query_params
      |> Map.get("currency", "")
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    with {:ok, currencies} <- Currency.cast_many(currencies_str),
         {:ok, quotes} <- ArchethicFAS.get_current(currencies) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(quotes))
    else
      {:error, {:invalid_currency, currency}} ->
        conn
        |> send_resp(400, "Bad request: invalid currency: #{currency}")

      {:error, reason} ->
        Logger.warning("GetCurrent failed: #{reason}")

        conn
        |> send_resp(500, "Internal error")
    end
  end
end
