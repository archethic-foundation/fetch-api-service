defmodule ArchethicFAS.QuotesHistorical.Scheduler do
  @moduledoc """
  Responsible of hydrating the cache every scheduling interval
  """

  alias ArchethicFAS.Quotes.UCID
  alias ArchethicFAS.Quotes.Cache
  alias ArchethicFAS.QuotesHistorical.Interval

  use GenServer
  @vsn 1

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    [next | remaining] = Interval.list()
    send(self(), {:tick, next})
    {:ok, %{remaining: remaining}}
  end

  def handle_info({:tick, interval}, state = %{remaining: []}) do
    [next | remaining] = Interval.list()

    Process.send_after(
      self(),
      {:tick, next},
      Application.fetch_env!(:archethic_fas, __MODULE__) |> Keyword.fetch!(:schedule_interval)
    )

    hydrate(interval)

    {:noreply, %{state | remaining: remaining}}
  end

  def handle_info({:tick, interval}, state = %{remaining: [next | remaining]}) do
    Process.send_after(
      self(),
      {:tick, next},
      Application.fetch_env!(:archethic_fas, __MODULE__)
      |> Keyword.fetch!(:schedule_interval)
    )

    hydrate(interval)

    {:noreply, %{state | remaining: remaining}}
  end

  defp hydrate(interval) do
    Enum.each(UCID.list(), fn ucid ->
      Cache.hydrate_history(ucid, interval)
    end)
  end
end
