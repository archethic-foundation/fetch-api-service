defmodule ArchethicFAS.Quotes do
  @moduledoc """
  Everything related to cryptoassets quotes
  """

  alias __MODULE__.Cache
  alias __MODULE__.UCID
  alias __MODULE__.Provider.CoinMarketCap

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
  Return the latest quotes of given cryptoassets
  Direct from providers.
  """
  @spec fetch_latest(list(UCID.t())) ::
          {:ok, %{UCID.t() => float()}} | {:error, String.t()}
  def fetch_latest(ucids) do
    CoinMarketCap.fetch_latest(ucids)
  end
end
