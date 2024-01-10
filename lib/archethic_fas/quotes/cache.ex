defmodule ArchethicFAS.Quotes.Cache do
  @moduledoc """
  Cache the latest quotes until it's overwritten
  """

  alias ArchethicFAS.Quotes
  alias ArchethicFAS.Quotes.Currency

  use GenServer
  require Logger

  @vsn 1
  @table :archethic_fas_quotes_cache

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_latest() :: {:ok, %{Currency.t() => float()}} | {:error, String.t()}
  def get_latest() do
    case :ets.lookup(@table, :latest) do
      [{:latest, value}] -> value
      [] -> {:error, "Value not cached yet"}
    end
  end

  def hydrate do
    GenServer.call(__MODULE__, :hydrate)
  end

  def init([]) do
    :ets.new(@table, [:named_table, :set, :public])

    {:ok, :no_state}
  end

  def handle_call(:hydrate, _from, state) do
    case Quotes.fetch_latest(Currency.list()) do
      {:ok, result} ->
        :ets.insert(@table, {:latest, {:ok, result}})
        {:reply, {:ok, result}, state}

      {:error, _reason} = e ->
        :ets.delete(@table, :latest)
        {:reply, e, state}
    end
  end
end
