defmodule ArchethicPrice.Provider.CoinMarketCap do
  @moduledoc false

  alias ArchethicPrice.Currency
  alias ArchethicPrice.Provider

  @behaviour Provider

  @config Application.compile_env!(:archethic_price, __MODULE__)

  @doc """
  Return the latest quotes of given currencies on this provider
  """
  @spec get_current(list(Currency.t())) ::
          {:ok, %{Currency.t() => float()}} | {:error, String.t()}
  def get_current(currencies) do
    ucids = currencies_to_ucids(currencies)

    case fetch_current(ucids) do
      {:ok, prices_by_ucid} ->
        {:ok, convert_ucids_to_currencies(prices_by_ucid)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp currencies_to_ucids(currencies) do
    currencies
    |> Enum.map(&Currency.to_ucid/1)
  end

  defp convert_ucids_to_currencies(map) do
    map
    |> Enum.map(fn {ucid, usd_price} ->
      {Currency.from_ucid(ucid), usd_price}
    end)
    |> Enum.into(%{})
  end

  defp fetch_current([]), do: {:ok, %{}}

  defp fetch_current(ucids) do
    query = URI.encode_query(%{id: Enum.join(ucids, ",")})
    path = "/v2/cryptocurrency/quotes/latest?#{query}"
    opts = [transport_opts: conf(:transport_opts, [])]

    with {:ok, conn} <- Mint.HTTP.connect(:https, conf(:endpoint), 443, opts),
         {:ok, conn, _} <- Mint.HTTP.request(conn, "GET", path, headers(), nil),
         {:ok, %{body: body, status: 200}} <- stream_response(conn),
         {:ok, response} <- Jason.decode(body) do
      {:ok, extract_quotes_from_response(response, ucids)}
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

  defp headers() do
    [
      {"X-CMC_PRO_API_KEY", conf(:key)},
      {"Accept", "application/json"}
    ]
  end

  defp conf(key) do
    Keyword.fetch!(@config, key)
  end

  defp conf(key, default) do
    Keyword.get(@config, key, default)
  end

  defp stream_response(conn, acc0 \\ %{status: 0, data: [], done: false}) do
    receive do
      message ->
        case Mint.HTTP.stream(conn, message) do
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
              {:ok, %{status: acc2.status, body: Enum.join(acc2.data)}}
            else
              stream_response(conn, acc2)
            end

          {:error, conn, reason, responses} ->
            {:error, conn, reason, responses}
        end
    end
  end
end
