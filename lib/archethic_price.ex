defmodule ArchethicPrice do
  @moduledoc false

  alias __MODULE__.Currency
  alias __MODULE__.Provider.CoinMarketCap

  @doc """
  Return the average price of given currencies
  by querying multiple providers
  """
  @spec get_current(list(Currency.t())) ::
          {:ok, %{Currency.t() => float()}} | {:error, String.t()}
  def get_current(currencies) do
    CoinMarketCap.get_current(currencies)
  end
end
