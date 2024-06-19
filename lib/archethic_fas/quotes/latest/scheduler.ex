defmodule ArchethicFAS.QuotesLatest.Scheduler do
  @moduledoc """
  Responsible of hydrating the cache every few minutes
  """

  alias ArchethicFAS.Quotes.Cache

  use GenServer
  @vsn 1

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    send(self(), :tick)
    {:ok, :no_state}
  end

  def handle_info(:tick, state) do
    Cache.hydrate_latest()

    Process.send_after(
      self(),
      :tick,
      Application.fetch_env!(:archethic_fas, __MODULE__) |> Keyword.fetch!(:schedule_interval)
    )

    {:noreply, state}
  end
end
