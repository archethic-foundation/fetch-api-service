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
    # to avoid API restriction we do one operation per minute
    :timer.send_interval(:timer.minutes(1), self(), :tick)
    :timer.send_interval(:timer.hours(1), self(), :tick_hour)
    :timer.send_interval(:timer.hours(24), self(), :tick_day)

    {:ok, %{remaining: Interval.list()}}
  end

  def handle_info(:tick, state = %{remaining: []}) do
    {:noreply, state}
  end

  def handle_info(:tick, %{remaining: [interval | rest]}) do
    hydrate(interval)
    {:noreply, %{remaining: rest}}
  end

  def handle_info(:tick_hour, %{remaining: remaining}) do
    {:noreply, %{remaining: [:hourly, :daily | remaining]}}
  end

  def handle_info(:tick_day, %{remaining: remaining}) do
    {:noreply, %{remaining: [:weekly, :biweekly, :monthly, :bimonthly, :yearly | remaining]}}
  end

  defp hydrate(interval) do
    Enum.each(UCID.list(), fn ucid ->
      Cache.hydrate_history(ucid, interval)
    end)
  end
end
