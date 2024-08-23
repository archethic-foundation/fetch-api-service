defmodule ArchethicFAS.AESwap.Cache do
  @moduledoc """

  """

  use GenServer
  require Logger

  @vsn 1
  @table :archethic_fas_aeswap_cache

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_tvl() :: {:ok, float()} | {:error, :not_cached}
  def get_tvl() do
    case :ets.lookup(@table, :latest) do
      [{:latest, value}] ->
        {:ok, value}

      [] ->
        {:error, :not_cached}
    end
  end

  @spec set_tvl(float()) :: :ok
  def set_tvl(tvl) when is_float(tvl) do
    :ets.insert(@table, {:latest, tvl})
    :ets.insert(@table, {DateTime.utc_now(), tvl})
    :ok
  end

  def init([]) do
    :ets.new(@table, [:named_table, :set, :public])

    {:ok, %{tasks: %{}}}
  end
end
