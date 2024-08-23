defmodule ArchethicFAS.AESwap do
  require Logger

  alias __MODULE__.Cache
  alias ArchethicFAS.ArchethicApi
  alias ArchethicFAS.Quotes
  alias ArchethicFAS.UCID

  @spec get_tvl() :: {:ok, float()} | :error
  def get_tvl() do
    case Cache.get_tvl() do
      {:ok, tvl} ->
        {:ok, tvl}

      {:error, :not_cached} ->
        fetch_tvl()
        |> tap(fn
          {:ok, tvl} -> Cache.set_tvl(tvl)
          _ -> :ignore
        end)
    end
  end

  @spec fetch_tvl() :: {:ok, float()} | :error
  def fetch_tvl() do
    {:ok, quotes} = UCID.list() |> Quotes.get_latest()

    case get_pools() do
      {:ok, pools} ->
        tvl =
          Enum.reduce(pools, 0, fn pool, acc ->
            [token1, token2] = pool["tokens"] |> String.split("/")

            case {UCID.from_archethic(token1), UCID.from_archethic(token2)} do
              {ucid1, ucid2} when is_integer(ucid1) and is_integer(ucid2) ->
                {:ok, info} = get_pool_infos(pool["address"])

                acc +
                  info["token1"]["reserve"] * quotes[ucid1] +
                  info["token2"]["reserve"] * quotes[ucid2]

              {ucid, _} when is_integer(ucid) ->
                {:ok, info} = get_pool_infos(pool["address"])
                acc + info["token1"]["reserve"] * quotes[ucid] * 2

              {_, ucid} when is_integer(ucid) ->
                {:ok, info} = get_pool_infos(pool["address"])
                acc + info["token2"]["reserve"] * quotes[ucid] * 2

              _ ->
                acc
            end
          end)

        {:ok, tvl}

      err ->
        Logger.error("Fetch TVL err: #{inspect(err)}")
        :error
    end
  end

  defp get_pools() do
    Application.fetch_env!(:archethic_fas, __MODULE__)
    |> Keyword.fetch!(:router_address)
    |> ArchethicApi.call_contract_function("get_pool_list", [])
  end

  defp get_pool_infos(pool_address) do
    ArchethicApi.call_contract_function(pool_address, "get_pool_infos", [])
  end
end
