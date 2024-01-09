defmodule ArchethicFAS.Provider.CoinMarketCapTest do
  @moduledoc """
  These tests are running on the sandbox-api from CMC.
  Real HTTP queries are done.
  """
  use ExUnit.Case
  alias ArchethicFAS.Provider.CoinMarketCap

  describe "get_current/1" do
    test "empty list should return an empty response" do
      assert {:ok, %{}} = CoinMarketCap.get_current([])
    end

    test "should return a OK response" do
      assert {:ok, map} = CoinMarketCap.get_current([:eth])
      assert [:eth] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:matic])
      assert [:matic] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:bitcoin])
      assert [:bitcoin] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:bnb])
      assert [:bnb] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:uco])
      assert [:uco] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:eth, :matic, :bitcoin, :bnb, :uco])
      assert 5 = map_size(map)
      assert Enum.all?(Map.values(map), &is_float/1)
    end
  end
end
