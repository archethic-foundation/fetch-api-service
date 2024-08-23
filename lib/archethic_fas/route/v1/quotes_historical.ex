defmodule ArchethicFAS.Route.V1.QuotesHistorical do
  @moduledoc """
  Return the latest quotes for given currencies
  """
  alias ArchethicFAS.QuotesHistorical.Interval
  alias ArchethicFAS.Quotes
  alias ArchethicFAS.UCID

  require Logger
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    with {:ok, ucid, interval} <- extract_params(conn),
         {:ok, quotes} <- Quotes.get_history(ucid, interval) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(quotes))
    else
      {:error, :missing_ucid_parameter} ->
        conn
        |> send_resp(400, "Bad request: missing ucids parameter")

      {:error, {:non_handled_ucid, ucid}} ->
        conn
        |> send_resp(400, "Bad request: non handled ucid: #{ucid}")

      {:error, :missing_interval_parameter} ->
        conn
        |> send_resp(400, "Bad request: missing interval parameter")

      {:error, :invalid_interval_parameter} ->
        conn
        |> send_resp(400, "Bad request: invalid interval parameter")

      {:error, reason} ->
        Logger.warning("/v1/quotes/historical failed: #{reason}")

        conn
        |> send_resp(500, "Internal error")
    end
  end

  defp extract_params(conn) do
    with {:ok, ucid} <- extract_ucid(conn),
         {:ok, interval} <- extract_interval(conn) do
      {:ok, ucid, interval}
    end
  end

  defp extract_ucid(conn) do
    case Map.get(conn.query_params, "ucid") do
      nil ->
        {:error, :missing_ucid_parameter}

      ucid ->
        ucid = String.to_integer(ucid)

        if UCID.valid?([ucid]) do
          {:ok, ucid}
        else
          {:error, {:non_handled_ucid, ucid}}
        end
    end
  end

  defp extract_interval(conn) do
    case Map.get(conn.query_params, "interval") do
      nil ->
        {:error, :missing_interval_parameter}

      interval ->
        case Interval.parse(interval) do
          {:ok, parsed_interval} -> {:ok, parsed_interval}
          :error -> {:error, :invalid_interval_parameter}
        end
    end
  end
end
