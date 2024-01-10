defmodule ArchethicFAS.Route.V1.QuotesLatest do
  @moduledoc """
  Return the latest quotes for given currencies
  """
  alias ArchethicFAS.Quotes
  alias ArchethicFAS.Quotes.Currency

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
         {:ok, quotes} <- Quotes.get_latest(currencies) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(quotes))
    else
      {:error, {:invalid_currency, currency}} ->
        conn
        |> send_resp(400, "Bad request: invalid currency: #{currency}")

      {:error, reason} ->
        Logger.warning("/v1/quotes/latest failed: #{reason}")

        conn
        |> send_resp(500, "Internal error")
    end
  end
end
