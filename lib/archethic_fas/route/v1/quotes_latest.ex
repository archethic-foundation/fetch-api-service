defmodule ArchethicFAS.Route.V1.QuotesLatest do
  @moduledoc """
  Return the latest quotes for given currencies
  """
  alias ArchethicFAS.Quotes
  alias ArchethicFAS.Quotes.UCID

  require Logger
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    with {:ok, ucids} <- extract_ucids(conn),
         :ok <- check_ucids(ucids),
         {:ok, quotes} <- Quotes.get_latest(ucids) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(quotes))
    else
      {:error, :missing_ucids_parameter} ->
        conn
        |> send_resp(400, "Bad request: missing ucids parameter")

      {:error, {:invalid_ucid, str}} ->
        conn
        |> send_resp(400, "Bad request: invalid ucid: #{str}")

      {:error, {:non_handled_ucids, ucids}} ->
        conn
        |> send_resp(400, "Bad request: non handled ucids: #{Enum.join(ucids, ", ")}")

      {:error, reason} ->
        Logger.warning("/v1/quotes/latest failed: #{reason}")

        conn
        |> send_resp(500, "Internal error")
    end
  end

  defp extract_ucids(conn) do
    case conn.query_params
         |> Map.get("ucids", "")
         |> String.split(",")
         |> Enum.map(&String.trim/1) do
      [""] -> {:error, :missing_ucids_parameter}
      strs -> strings_to_integers(strs)
    end
  end

  defp strings_to_integers(sts, acc \\ [])
  defp strings_to_integers([], acc), do: {:ok, acc}

  defp strings_to_integers([str | rest], acc) do
    case Integer.parse(str) do
      {int, ""} ->
        strings_to_integers(rest, [int | acc])

      _ ->
        {:error, {:invalid_ucid, str}}
    end
  end

  defp check_ucids(ucids) do
    difference = MapSet.difference(MapSet.new(ucids), MapSet.new(UCID.list()))

    case MapSet.size(difference) do
      0 ->
        :ok

      _ ->
        {:error, {:non_handled_ucids, MapSet.to_list(difference)}}
    end
  end
end
