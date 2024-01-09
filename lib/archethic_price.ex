defmodule ArchethicPrice do
  @moduledoc false

  @type currency :: :eth | :bnb | :matic | :bitcoin | :uco

  @ucids Application.compile_env!(:archethic_price, :ucids)

  @spec valid_currency(currency()) :: boolean()
  def valid_currency(:eth), do: true
  def valid_currency(:bnb), do: true
  def valid_currency(:matic), do: true
  def valid_currency(:bitcoin), do: true
  def valid_currency(:uco), do: true
  def valid_currency(_), do: false

  @spec valid_currencies(list(currency())) :: boolean()
  def valid_currencies(currencies) do
    Enum.all?(currencies, &valid_currency/1)
  end

  @doc """
  Return the UCID of the currency.
  This assumes a config-present currency.
  """
  @spec currency_to_ucid(currency()) :: pos_integer()
  def currency_to_ucid(currency) do
    Map.fetch!(@ucids, currency)
  end

  @doc """
  Return the UCID of the currency.
  This assumes a config-present ucid.
  """
  @spec ucid_to_currency(pos_integer()) :: currency()
  def ucid_to_currency(ucid) do
    Map.filter(@ucids, fn
      {_, ^ucid} -> true
      _ -> false
    end)
    |> Map.keys()
    |> hd()
  end
end
