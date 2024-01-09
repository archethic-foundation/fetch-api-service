defmodule ArchethicPrice.Provider.CoinMarketCap do
  @moduledoc false

  @behaviour ArchethicPrice.Provider

  @config Application.compile_env!(:archethic_price, __MODULE__)

  @spec get_current(list(ArchethicPrice.currency())) ::
          {:ok, %{ArchethicPrice.currency() => float()}}
          | {:error, :invalid_currency}
  def get_current(currencies) do
    with true <- ArchethicPrice.valid_currencies(currencies),
         ucids <- currencies_to_ucids(currencies),
         {:ok, prices_by_ucid} <- fetch_current(ucids) do
      {:ok, convert_ucids_to_currencies(prices_by_ucid)}
    else
      false ->
        {:error, :invalid_currency}
    end
  end

  defp currencies_to_ucids(currencies) do
    currencies
    |> Enum.map(&ArchethicPrice.currency_to_ucid/1)
  end

  defp convert_ucids_to_currencies(map) do
    map
    |> Enum.map(fn {ucid, usd_price} ->
      {ArchethicPrice.ucid_to_currency(ucid), usd_price}
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

            cond do
              acc2.done ->
                {:ok, %{status: acc2.status, body: Enum.join(acc2.data)}}

              true ->
                stream_response(conn, acc2)
            end

          {:error, _, reason, _} ->
            {:error, reason}
        end
    end
  end
end
