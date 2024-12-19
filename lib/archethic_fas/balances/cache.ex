defmodule ArchethicFAS.Balances.Cache do
  @moduledoc false

  use GenServer
  require Logger

  @vsn 1
  @table :archethic_fas_balances_cache

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_balance(String.t()) :: {:ok, integer()} | {:error, :not_cached}
  def get_balance(address) do
    case :ets.lookup(@table, address) do
      [{_, balance}] ->
        {:ok, balance}

      [] ->
        {:error, :not_cached}
    end
  end

  @spec set_balances(%{String.t() => integer()}) :: :ok
  def set_balances(balance_by_pool) do
    Enum.each(balance_by_pool, &:ets.insert(@table, &1))
  end

  def init([]) do
    :ets.new(@table, [:named_table, :set, :public])

    {:ok, :no_state}
  end
end
