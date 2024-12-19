defmodule ArchethicFAS.ArchethicGraphql do
  def query(q) do
    body = Jason.encode!(%{query: q})
    path = "/api/graphql"
    opts = [transport_opts: conf(:transport_opts, [])]

    with {:ok, conn} <- Mint.HTTP.connect(:https, conf(:endpoint), 443, opts),
         {:ok, conn, _} <- Mint.HTTP.request(conn, "POST", path, headers(), body),
         {:ok, conn, %{body: body, status: 200}} <- stream_response(conn),
         {:ok, _} <- Mint.HTTP.close(conn),
         {:ok, response} <- Jason.decode(body) do
      {:ok, response["data"]}
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

  defp headers() do
    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]
  end

  defp conf(key) do
    case conf(key, nil) do
      nil -> raise "Missing config #{key}"
      value -> value
    end
  end

  defp conf(key, default) do
    config = Application.get_env(:archethic_fas, ArchethicFAS.ArchethicApi, [])
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
