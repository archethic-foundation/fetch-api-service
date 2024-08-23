defmodule ArchethicFAS.QuotesHistorical.Provider.Coingecko do
  @moduledoc false

  alias ArchethicFAS.QuotesHistorical.Provider

  @behaviour Provider

  @doc """
  Return the historical quotes of given currency on this provider for a range of time
  """
  @spec fetch_history(coin :: String.t(), from :: DateTime.t(), to :: DateTime.t()) ::
          {:ok, map()} | {:error, String.t()}
  def fetch_history(coin, from, to) do
    query =
      URI.encode_query(%{
        vs_currency: "usd",
        from: DateTime.to_unix(from),
        to: DateTime.to_unix(to)
      })

    path = "/api/v3/coins/#{coin}/market_chart/range?#{query}"
    opts = [transport_opts: conf(:transport_opts, [])]

    with {:ok, conn} <- Mint.HTTP.connect(:https, "api.coingecko.com", 443, opts),
         {:ok, conn, _} <- Mint.HTTP.request(conn, "GET", path, headers(), nil),
         {:ok, conn, %{body: body, status: 200}} <- stream_response(conn),
         {:ok, _} <- Mint.HTTP.close(conn),
         {:ok, response} <- Jason.decode(body) do
      {:ok, response}
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

      {:ok, %Mint.HTTP2{}, %{status: 429}} ->
        {:error, "provider reach limit"}
    end
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

  defp headers() do
    [
      {"x-cg-demo-api-key", conf(:key)}
    ]
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
