defmodule ArchethicFAS.UCID do
  @moduledoc false

  @type t :: pos_integer()

  @doc """
  Return all handled ucids
  """
  @spec list() :: list(t())
  def list() do
    Application.fetch_env!(:archethic_fas, :coins)
    |> Enum.map(& &1.ucid)
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
  Get the coingecko name
  """
  @spec to_coingecko(t()) :: String.t() | :error
  def to_coingecko(ucid) do
    Application.fetch_env!(:archethic_fas, :coins)
    |> Enum.find(&(&1.ucid == ucid))
    |> then(fn
      nil -> :error
      conf -> conf.coingecko
    end)
  end

  @doc """
  Get the archethic token address
  """
  @spec to_archethic(t()) :: String.t() | :error
  def to_archethic(ucid) do
    Application.fetch_env!(:archethic_fas, :coins)
    |> Enum.find(&(&1.ucid == ucid))
    |> then(fn
      nil -> :error
      conf -> conf.archethic
    end)
  end

  @doc """
  Get the UCID from a token address
  """
  @spec from_archethic(String.t()) :: t() | :error
  def from_archethic(token_address) do
    Application.fetch_env!(:archethic_fas, :coins)
    |> Enum.find(&(&1.archethic == token_address))
    |> then(fn
      nil -> :error
      conf -> conf.ucid
    end)
  end

  @doc """
  Return true if the ucid is replaced by another
  """
  @spec replaced?(ucid :: t()) :: boolean()
  def replaced?(ucid) do
    Application.fetch_env!(:archethic_fas, :coins)
    |> Enum.find(&(&1.ucid == ucid))
    |> Map.has_key?(:replaced_by)
  end

  @doc """
  Get the ucid which replaced the given one
  """
  @spec get_replaced_by(ucid :: t()) :: boolean()
  def get_replaced_by(ucid) do
    Application.fetch_env!(:archethic_fas, :coins)
    |> Enum.find(&(&1.ucid == ucid))
    |> Map.fetch!(:replaced_by)
  end
end
