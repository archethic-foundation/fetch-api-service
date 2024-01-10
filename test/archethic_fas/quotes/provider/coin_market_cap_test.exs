defmodule ArchethicFAS.Quotes.Provider.CoinMarketCapTest do
  @moduledoc """
  These tests are running on the sandbox-api from CMC.
  Real HTTP queries are done.
  """
  alias ArchethicFAS.Quotes.Provider.CoinMarketCap

  use ExUnit.Case
  doctest CoinMarketCap

  describe "fetch_latest/1" do
    test "empty list should return an empty response" do
      assert {:ok, %{}} = CoinMarketCap.fetch_latest([])
    end

    test "should return a OK response" do
      assert {:ok, map} = CoinMarketCap.fetch_latest([:eth])
      assert [:eth] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([:matic])
      assert [:matic] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([:btc])
      assert [:btc] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([:bnb])
      assert [:bnb] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([:uco])
      assert [:uco] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([:eth, :matic, :btc, :bnb, :uco])
      assert 5 = map_size(map)
      assert Enum.all?(Map.values(map), &is_float/1)
    end
  end
end
