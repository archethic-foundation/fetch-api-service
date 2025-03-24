defmodule ArchethicFAS.QuotesLatest.Provider.CoinMarketCap do
  @moduledoc false

  alias ArchethicFAS.UCID
  alias ArchethicFAS.QuotesLatest.Provider

  @behaviour Provider

  @doc """
  Return the latest quotes of given currencies on this provider
  """
  @spec fetch_latest(list(UCID.t())) ::
          {:ok, %{UCID.t() => float()}} | {:error, String.t()}
  def fetch_latest([]), do: {:ok, %{}}

  def fetch_latest(ucids) do
    {replaced_ucids, ucids} = Enum.split_with(ucids, &UCID.replaced?/1)

    ucids =
      replaced_ucids |> Enum.map(&UCID.get_replaced_by/1) |> Enum.concat(ucids) |> Enum.uniq()

    query = URI.encode_query(%{id: Enum.join(ucids, ",")})
    path = "/v2/cryptocurrency/quotes/latest?#{query}"
    opts = [transport_opts: conf(:transport_opts, [])]

    with {:ok, conn} <- Mint.HTTP.connect(:https, conf(:endpoint), 443, opts),
         {:ok, conn, _} <- Mint.HTTP.request(conn, "GET", path, headers(), nil),
         {:ok, conn, %{body: body, status: 200}} <- stream_response(conn),
         {:ok, _} <- Mint.HTTP.close(conn),
         {:ok, response} <- Jason.decode(body) do
      quotes =
        response |> extract_quotes_from_response(ucids) |> insert_replaced_quotes(replaced_ucids)

      {:ok, quotes}
    else
      # connect errors
      {:error, error = %Mint.TransportError{}} ->
        {:error, Exception.message(error)}

      {:error, error = %Mint.HTTPError{}} ->
        {:error, Exception.message(error)}

      # request errors
      {:error, _conn, error = %Mint.TransportError{}} ->
        {:error, Exception.message(error)}

      {:error, _conn, error = %Mint.HTTPError{}} ->
        {:error, Exception.message(error)}

      # stream errors
      {:error, _conn, error = %Mint.TransportError{}, _responses} ->
        {:error, Exception.message(error)}

      {:error, _conn, error = %Mint.HTTPError{}, _responses} ->
        {:error, Exception.message(error)}

      # jason
      {:error, %Jason.DecodeError{}} ->
        {:error, "provider returned an invalid json"}
    end
  end

  defp extract_quotes_from_response(res, ucids) do
    ucids
    |> Enum.map(fn ucid ->
      {:ok, [usd_price]} = ExJSONPath.eval(res, "$.data['#{ucid}'].quote.USD.price")
      {ucid, usd_price}
    end)
    |> Enum.into(%{})
  end

  defp insert_replaced_quotes(quotes, replaced_ucids) do
    Map.new(replaced_ucids, fn replaced_ucid ->
      replacement_ucid = UCID.get_replaced_by(replaced_ucid)
      quote = Map.fetch!(quotes, replacement_ucid)
      {replaced_ucid, quote}
    end)
    |> Map.merge(quotes)
  end

  defp headers() do
    [
      {"X-CMC_PRO_API_KEY", conf(:key)},
      {"Accept", "application/json"}
    ]
  end

  defp conf(key) do
    case conf(key, nil) do
      nil -> raise "Missing config #{key}"
      value -> value
    end
  end

  defp conf(key, default) do
    config = Application.get_env(:archethic_fas, __MODULE__, [])
    Keyword.get(config, key, default)
  end

  defp stream_response(conn, acc0 \\ %{status: 0, data: [], done: false}) do
    receive do
      message ->
        case Mint.HTTP.stream(conn, message) do
          :unknown ->
            IO.inspect(message)

          {:ok, conn, responses} ->
            acc2 =
              Enum.reduce(responses, acc0, fn
                {:status, _, status}, acc1 ->
                  %{acc1 | status: status}

                {:data, _, data}, acc1 ->
                  %{acc1 | data: acc1.data ++ [data]}

                {:headers, _, _}, acc1 ->
                  acc1

                {:done, _}, acc1 ->
                  %{acc1 | done: true}
              end)

            if acc2.done do
              {:ok, conn, %{status: acc2.status, body: Enum.join(acc2.data)}}
            else
              stream_response(conn, acc2)
            end

          {:error, conn, reason, responses} ->
            {:error, conn, reason, responses}
        end
    end
  end
end
