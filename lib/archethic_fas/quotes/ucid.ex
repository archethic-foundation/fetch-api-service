defmodule ArchethicFAS.Quotes.UCID do
  @moduledoc false

  @type t :: pos_integer()

  @doc """
  Return all handled ucids
  """
  @spec list() :: list(t())
  def list() do
    Application.fetch_env!(:archethic_fas, :ucids)
  end

  @doc """
  Determins if the a list of UCID are valid
  """
  @spec valid?(list(t())) :: boolean()
  def valid?(ucids) when is_list(ucids) do
    difference = MapSet.difference(MapSet.new(ucids), MapSet.new(list()))
    MapSet.size(difference) == 0
  end

  @doc """
  Get name of the UCID
  """
  @spec name(t()) :: String.t()
  def name(6887), do: "archethic"
  def name(3890), do: "matic-network"
  def name(1839), do: "binancecoin"
  def name(1), do: "bitcoin"
  def name(1027), do: "ethereum"
  def name(3408), do: "usd-coin"
  def name(20920), do: "monerium-eur-money"
end
