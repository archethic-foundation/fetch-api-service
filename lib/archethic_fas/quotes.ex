defmodule ArchethicFAS.Quotes do
  @moduledoc """
  Everything related to crypto assets quotes
  """

  alias __MODULE__.Cache
  alias __MODULE__.Currency
  alias __MODULE__.Provider.CoinMarketCap

  @doc """
  Return the latest quotes of given currencies.
  Behind a cache.
  """
  @spec get_latest(list(Currency.t())) ::
          {:ok, %{Currency.t() => float()}} | {:error, String.t()}
  def get_latest(currencies) do
    case Cache.get_latest() do
      {:ok, all_quotes} ->
        {:ok,
         Map.filter(all_quotes, fn {currency, _} ->
           currency in currencies
         end)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Return the latest quotes of given currencies.
  Direct from providers.
  """
  @spec fetch_latest(list(Currency.t())) ::
          {:ok, %{Currency.t() => float()}} | {:error, String.t()}
  def fetch_latest(currencies) do
    CoinMarketCap.fetch_latest(currencies)
  end
end
