defmodule ArchethicFAS.Quotes.Cache do
  @moduledoc """
  Cache the latest quotes until it's overwritten
  """

  alias ArchethicFAS.Quotes
  alias ArchethicFAS.Quotes.UCID

  use GenServer
  require Logger

  @vsn 1
  @table :archethic_fas_quotes_cache

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_latest() :: {:ok, %{UCID.t() => float()}} | {:error, String.t()}
  def get_latest() do
    case :ets.lookup(@table, :latest) do
      [{:latest, value}] ->
        {:ok, value}

      [] ->
        hydrate()
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
    case Quotes.fetch_latest(UCID.list()) do
      {:ok, result} ->
        :ets.insert(@table, {:latest, result})
        {:reply, {:ok, result}, state}

      e = {:error, reason} ->
        Logger.warning("Hydrating failed: #{inspect(reason)}")
        :ets.delete(@table, :latest)
        {:reply, e, state}
    end
  end
end
