defmodule ArchethicFAS.AESwap.Scheduler do
  @moduledoc """
  Hydrate the cache once per hour
  """

  alias ArchethicFAS.AESwap
  alias ArchethicFAS.AESwap.Cache
  require Logger

  use GenServer
  @vsn 1

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    :timer.send_interval(:timer.hours(1), :tick)

    # first request after a few seconds
    # to give some time for the quotes to be ready
    Process.send_after(self(), :tick, 2000)

    {:ok, :no_state}
  end

  def handle_info(:tick, state) do
    Logger.debug("hydrate AESwap TVL")
    {:ok, tvl} = AESwap.fetch_tvl()
    :ok = Cache.set_tvl(tvl)

    {:noreply, state}
  end
end
