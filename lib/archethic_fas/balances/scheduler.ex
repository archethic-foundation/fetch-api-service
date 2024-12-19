defmodule ArchethicFAS.Balances.Scheduler do
  @moduledoc """
  Hydrate the cache once per hour
  """

  alias ArchethicFAS.Balances
  alias ArchethicFAS.Balances.Cache
  require Logger

  use GenServer
  @vsn 1

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    :timer.send_interval(:timer.hours(1), :tick)
    Process.send_after(self(), :tick, 0)

    {:ok, :no_state}
  end

  def handle_info(:tick, state) do
    Logger.debug("hydrate genesis pool balance")
    balances = Balances.fetch_genesis_pools_balances()
    :ok = Cache.set_balances(balances)

    {:noreply, state}
  end
end
