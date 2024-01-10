defmodule ArchethicFAS.Quotes.Scheduler do
  @moduledoc """
  Responsible of calling MFA every N ms
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
    send(Cache, :hydrate)

    Process.send_after(self(), :tick, 60_000)
    {:noreply, state}
  end
end
