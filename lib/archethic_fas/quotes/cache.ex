defmodule ArchethicFAS.Quotes.Cache do
  @moduledoc """
  Cache the latest quotes until it's overwritten
  """

  alias ArchethicFAS.Quotes
  alias ArchethicFAS.UCID
  alias ArchethicFAS.QuotesHistorical.Interval

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
        hydrate_latest()
    end
  end

  @spec get_history(UCID.t(), Interval.t()) :: {:ok, map()} | {:error, String.t()}
  def get_history(ucid, interval) do
    case :ets.lookup(@table, {:history, ucid, interval}) do
      [{_, values}] ->
        {:ok, values}

      [] ->
        hydrate_history(ucid, interval)
    end
  end

  def hydrate_latest do
    GenServer.call(__MODULE__, :hydrate_latest)
  end

  def hydrate_history(ucid, interval) do
    GenServer.call(__MODULE__, {:hydrate_history, ucid, interval})
  end

  def init([]) do
    :ets.new(@table, [:named_table, :set, :public])

    {:ok, %{tasks: %{}}}
  end

  def handle_call(:hydrate_latest, from, state) do
    Logger.debug("hydrate latest quotes")
    %Task{ref: t_ref} = Task.async(fn -> Quotes.fetch_latest(UCID.list()) end)

    new_state =
      state
      |> Map.update!(
        :tasks,
        &Map.put(&1, t_ref, {:latest, from})
      )

    {:noreply, new_state}
  end

  def handle_call({:hydrate_history, ucid, interval}, from, state) do
    Logger.debug("hydrate #{UCID.to_coingecko(ucid)} for #{interval} interval")

    %Task{ref: t_ref} = Task.async(fn -> Quotes.fetch_history(ucid, interval) end)

    new_state =
      state
      |> Map.update!(
        :tasks,
        &Map.put(&1, t_ref, {{:history, ucid, interval}, from})
      )

    {:noreply, new_state}
  end

  def handle_info({ref, data}, state = %{tasks: tasks}) do
    case Map.pop(tasks, ref) do
      {nil, _} ->
        {:noreply, state}

      {{key, from}, tasks} ->
        case data do
          {:ok, result} ->
            :ets.insert(@table, {key, result})

          _ ->
            :ets.delete(@table, key)
        end

        GenServer.reply(from, data)
        {:noreply, %{state | tasks: tasks}}
    end
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state), do: {:noreply, state}
end
