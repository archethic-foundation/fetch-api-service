defmodule ArchethicPrice.Currency do
  @moduledoc """
  Everything related to currency
  """

  @ucids Application.compile_env!(:archethic_price, :ucids)

  @type t :: :eth | :bnb | :matic | :bitcoin | :uco

  @doc """
  Transform a string into a currency
  """
  @spec cast(String.t()) :: {:ok, t()} | :error
  def cast("eth"), do: {:ok, :eth}
  def cast("bnb"), do: {:ok, :bnb}
  def cast("matic"), do: {:ok, :matic}
  def cast("bitcoin"), do: {:ok, :bitcoin}
  def cast("uco"), do: {:ok, :uco}
  def cast(_), do: :error

  @spec cast_many(list(String.t())) ::
          {:ok, list(t())} | {:error, {:invalid_currency, String.t()}}
  def cast_many(currencies) do
    do_cast_many(currencies, [])
  end

  @doc """
  Return the UCID of the currency.
  This assumes a config-present currency.
  """
  @spec to_ucid(t()) :: pos_integer()
  def to_ucid(currency) do
    Map.fetch!(@ucids, currency)
  end

  @doc """
  Return the currency of the UCID.
  This assumes a config-present UCID.
  """
  @spec from_ucid(pos_integer()) :: t()
  def from_ucid(ucid) do
    Map.filter(@ucids, fn
      {_, ^ucid} -> true
      _ -> false
    end)
    |> Map.keys()
    |> hd()
  end

  # order does not matter
  defp do_cast_many([], acc), do: {:ok, acc}

  defp do_cast_many([str | rest], acc) do
    case cast(str) do
      :error ->
        {:error, {:invalid_currency, str}}

      {:ok, currency} ->
        do_cast_many(rest, [currency | acc])
    end
  end
end
