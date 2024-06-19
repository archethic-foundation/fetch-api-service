defmodule ArchethicFAS.Quotes do
  @moduledoc """
  Everything related to cryptoassets quotes
  """

  alias __MODULE__.Cache
  alias __MODULE__.UCID
  alias ArchethicFAS.QuotesHistorical.Interval
  alias ArchethicFAS.QuotesLatest.Provider.CoinMarketCap
  alias ArchethicFAS.QuotesHistorical.Provider.Coingecko

  @doc """
  Return the latest quotes of given cryptoassets.
  Behind a cache.
  """
  @spec get_latest(list(UCID.t())) ::
          {:ok, %{UCID.t() => float()}} | {:error, String.t()}
  def get_latest(ucids) do
    case Cache.get_latest() do
      {:ok, all_quotes} ->
        {:ok,
         Map.filter(all_quotes, fn {ucid, _} ->
           ucid in ucids
         end)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Return the latest quotes of given cryptoassets direct from provider.
  """
  @spec fetch_latest(list(UCID.t())) ::
          {:ok, %{UCID.t() => float()}} | {:error, String.t()}
  def fetch_latest(ucids) do
    CoinMarketCap.fetch_latest(ucids)
  end

  def get_history(ucid, interval) do
    case Cache.get_history(ucid, interval) do
      {:ok, quotes} ->
        {:ok, quotes}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Return the historical quotes of given cryptoasset direct from provider for range of days.
  """
  @spec fetch_history(non_neg_integer(), interval :: Interval.t()) ::
          {:ok, map()} | {:error, String.t()}
  def fetch_history(ucid, interval) do
    ucid
    |> UCID.name()
    |> Coingecko.fetch_history(
      Interval.get_datetime(interval),
      DateTime.utc_now()
    )
  end
end
