defmodule ArchethicFAS.Balances do
  alias ArchethicFAS.ArchethicGraphql
  alias ArchethicFAS.Balances.Cache

  require Logger

  @spec get_genesis_pools_balances() :: %{String.t() => integer() | nil}
  def get_genesis_pools_balances() do
    Application.get_env(:archethic_fas, :genesis_pools)
    |> Enum.map(fn {address, initial_amount} ->
      case Cache.get_balance(address) do
        {:ok, balance} ->
          {address, %{initial: initial_amount, current: balance}}

        {:error, :not_cached} ->
          Task.start(fn -> fetch_genesis_pools_balances() end)
          {address, %{initial: initial_amount, current: nil}}
      end
    end)
    |> Enum.into(%{})
  end

  def fetch_genesis_pools_balances() do
    addresses =
      Application.get_env(:archethic_fas, :genesis_pools)
      |> Map.keys()

    case ArchethicGraphql.query(balance_query(addresses)) do
      {:ok, response} ->
        response
        |> Enum.map(fn {"x" <> address, %{"uco" => uco}} ->
          {address, uco}
        end)
        |> Enum.into(%{})

      {:error, reason} ->
        Logger.error("Impossible to query genesis pools balances #{inspect(reason)}")
        []
    end
  end

  defp balance_query(addresses) do
    subqueries =
      addresses
      |> Enum.map(fn address ->
        "x#{address}: balance(address: \"#{address}\") { uco }"
      end)
      |> Enum.join("\n")

    """
    {
      #{subqueries}
    }
    """
  end
end
