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
      assert {:ok, map} = CoinMarketCap.fetch_latest([1027])
      assert [1027] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([3890])
      assert [3890] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([1])
      assert [1] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([1839])
      assert [1839] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([6887])
      assert [6887] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.fetch_latest([1027, 3890, 1, 1839, 6887])
      assert 5 = map_size(map)
      assert Enum.all?(Map.values(map), &is_float/1)
    end
  end
end
